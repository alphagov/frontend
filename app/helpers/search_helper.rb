module SearchHelper
  def show_tabs?(streams)
    streams.any?(&:anything_to_show?) || params[:organisation]
  end
end
