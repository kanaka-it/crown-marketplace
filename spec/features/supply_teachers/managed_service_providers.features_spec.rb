require 'rails_helper'

RSpec.feature 'Managed service providers', type: :feature do
  scenario 'Answers should not be pre-selected' do
    visit_supply_teachers_start

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer wants to hire a master vendor managed service' do
    supplier = create(:supply_teachers_supplier)

    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt', term: 'one_week', mark_up: 0.11)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt', term: 'twelve_weeks', mark_up: 0.12)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt', term: 'more_than_twelve_weeks', mark_up: 0.13)

    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt_sen', term: 'one_week', mark_up: 0.21)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt_sen', term: 'twelve_weeks', mark_up: 0.22)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt_sen', term: 'more_than_twelve_weeks', mark_up: 0.23)

    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'nominated', mark_up: 0.30)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'fixed_term', mark_up: 0.40)

    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    choose 'Master vendor'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Master vendor managed service')
    expect(page).to have_css('h2', text: supplier.name)

    expect(page).to have_rates(job_type: 'Qualified teacher: non-SEN roles', percentages: [11.0, 12.0, 13.0])
    expect(page).to have_rates(job_type: 'Qualified teacher: SEN roles', percentages: [21.0, 22.0, 23.0])
    expect(page).to have_rates(job_type: 'A specific person', percentages: [30.0, 30.0, 30.0])
    expect(page).to have_rates(job_type: 'Employed directly', percentages: [40.0, 40.0, 40.0])
  end

  scenario 'Buyer wants to hire a neutral vendor managed service' do
    supplier = create(:supply_teachers_supplier, name: 'neutral-vendor-supplier')

    create(:supply_teachers_neutral_vendor_rate,
           supplier: supplier, job_type: 'nominated', mark_up: 0.30)
    create(:supply_teachers_neutral_vendor_rate,
           supplier: supplier, job_type: 'daily_fee', daily_fee: 1.23, mark_up: nil)

    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    choose 'Neutral vendor'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Neutral vendor managed service')
    expect(page).to have_css('h2', text: 'neutral-vendor-supplier')

    expect(page).to have_text(/A 30.0% mark-up is charged/)
    expect(page).to have_text(/A £1.23 daily fee is charged/)
  end

  scenario 'Buyer changes mind about hiring a managed service provider' do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    choose 'Master vendor'
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')
    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field(I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider'))
  end

  scenario 'Buyer changes mind about hiring a master vendor managed service' do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    choose 'Master vendor'
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field('Master vendor')
  end

  scenario 'Buyer changes mind about hiring a neutral vendor managed service' do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    choose 'Neutral vendor'
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field('Neutral vendor')
  end

  private

  def have_rates(job_type:, percentages:, amount: nil)
    rate_patterns = if percentages.any?
                      percentages.map { |p| rate_pattern(p) }
                    else
                      [daily_fee_pattern(amount)]
                    end
    combined_pattern = [Regexp.escape(job_type), *rate_patterns].join('\s+')
    have_text(Regexp.new(combined_pattern))
  end

  def rate_pattern(percentage)
    format('%.1f%%', percentage).sub('.', Regexp.escape('.'))
  end

  def daily_fee_pattern(amount)
    "£#{amount}".sub('.', Regexp.escape('.'))
  end
end
