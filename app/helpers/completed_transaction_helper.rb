module CompletedTransactionHelper
  def promote_organ_donor_registration?
     organ_donor_registration_attributes && organ_donor_registration_attributes['promote_organ_donor_registration']
  end

  def organ_donor_registration_attributes
    @attributes ||= @publication.presentation_toggles && @publication.presentation_toggles['organ_donor_registration']
  end
end
