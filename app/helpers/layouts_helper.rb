module LayoutsHelper
  def layout_for_public_options(title:, body_classes: nil, homepage: false)
    {
      draft_watermark: draft_host?,
      title:,
      title_lang: I18n.locale,
      emergency_banner: render("govuk_web_banners/emergency_banner"),
      global_banner: render("govuk_web_banners/global_banner"),
      homepage:,
      show_app_promo_banner: show_app_promo_banner?,
      body_classes:,
    }
  end
end
