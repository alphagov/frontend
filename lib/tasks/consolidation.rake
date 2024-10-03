# We don't care much about the coverage of scaffolding files that are just used on the desktop during
# consolidation and are going to be removed.
# :nocov:
namespace :consolidation do
  desc <<~END_DESC
    Copy a locale key for all locales from government-frontend to frontend

    Usage:
      rake "consolidation:copy_translation[components]" # copies the whole components tree
      rake "consolidation:copy_translation[components.figure]" # copies just the components.figure tree

    Note that government-frontend needs to be checked out out in a sibling directory
  END_DESC
  task :copy_translation, [:key] => :environment do |_, args|
    abort("government-frontend not checked out in a sibling directory") unless Dir.exist?(Rails.root.join("../government-frontend"))

    key = args.fetch(:key, nil)
    key_parts = key.split(".")
    abort("You need to specify a key to copy") unless key

    puts("Copying #{key} translations from government-frontend to frontend")

    frontend_locale_files = Dir.entries(Rails.root.join("config/locales")).select { |name| name.end_with?(".yml") }.sort

    frontend_locale_files.each do |flf|
      government_frontend_keys = YAML.load(File.read(Rails.root.join("../government-frontend/config/locales", flf)))
      locale_key_parts = [flf.gsub(".yml", "")] + key_parts
      translation_tree = government_frontend_keys.dig(*locale_key_parts)
      abort("key #{key} not found in government-frontend's #{flf}") unless translation_tree

      if translation_tree.is_a?(Hash)
        get_leaf_paths(translation_tree).each { |leaf_path| LocaleUpdater.add_key(locale_key_parts.join(".") + leaf_path[0], leaf_path[1]) }
      else
        LocaleUpdater.add_key(locale_key_parts.join("."), translation_tree)
      end
    end
  end
end

def get_leaf_paths(tree, prefix: "")
  return [tree] if tree.is_a?(String) # Handle the case of one specific key/value

  leaf_paths = []
  tree.each_key do |key|
    if tree[key].is_a?(Hash)
      leaf_paths += get_leaf_paths(tree[key], prefix: prefix + ".#{key}")
    else
      leaf_paths << [prefix + ".#{key}", tree[key]]
    end
  end
  leaf_paths
end

class LocaleUpdater
  def self.add_key(key, value)
    forest = ::I18n::Tasks::Data::Tree::Siblings.from_key_names [key]
    if value
      puts("Trying to add #{key} = #{value}")
      forest.set_each_value!(value)
      # system("echo '#{key}' | i18n-tasks tree-convert -f keys -t yaml | i18n-tasks tree-set-value '#{value}' | i18n-tasks data-merge")
    else
      puts("Trying to add empty key #{key}")
      # system("echo '#{key}' | i18n-tasks tree-convert -f keys -t yaml | i18n-tasks data-merge")
    end
    I18n::Tasks::BaseTask.new.data.merge!(forest)
  end
end

# :nocov:
