require 'rails_helper'

RSpec.describe 'supply_teachers/journey/temp_to_perm_calculator.html.erb' do
  let(:step) { SupplyTeachers::Journey::TempToPermCalculator.new }
  let(:errors) { ActiveModel::Errors.new(step) }
  let(:journey) do
    instance_double(
      'Journey',
      errors: errors,
      current_step: step,
      previous_questions_and_answers: {}
    )
  end

  before do
    view.extend(ApplicationHelper)
    assign(:journey, journey)
    assign(:form_path, '/')
  end

  it 'does not include aria-describedby attribute' do
    render
    expect(rendered).not_to have_css('fieldset[aria-describedby]')
  end

  it 'does not display the error summary' do
    render
    expect(rendered).not_to have_css('.govuk-error-summary')
  end

  it 'does not include any error message classes' do
    render
    expect(rendered).not_to have_css('.govuk-form-group--error')
    expect(rendered).not_to have_css('.govuk-error-message')
  end

  it 'does not set the page title prefix' do
    render
    expect(view.content_for(:page_title_prefix)).to be_nil
  end

  context 'when the journey has an error in contract_start_date_day' do
    before do
      errors.add(:contract_start_date_day, 'error-message')
    end

    it 'links the fieldset to the error message' do
      render
      expect(rendered).to have_css('fieldset[aria-describedby="contract_start_date_day-error"]')
    end

    it 'displays the error summary' do
      render
      expect(rendered).to have_css('.govuk-error-summary')
    end

    it 'adds the form group error class' do
      render
      expect(rendered).to have_css('.govuk-form-group.govuk-form-group--error')
    end

    it 'adds the message to the field with the error' do
      render
      expect(rendered).to have_css('#contract_start_date_day-error.govuk-error-message', text: 'error-message')
    end

    it 'adds error class to the field in order to highlight it' do
      render
      expect(rendered).to have_css('#contract_start_date_day.govuk-input--error')
    end

    it 'adds an error prefix to the page title' do
      render
      expect(view.content_for(:page_title_prefix)).to match(t('layouts.application.error_prefix'))
    end

    context 'and the journey has an error in contract_start_date_month' do
      before do
        errors.add(:contract_start_date_month, 'error-message')
      end

      it 'still links the fieldset to the contract_start_date_day error message' do
        render
        expect(rendered).to have_css('fieldset[aria-describedby~="contract_start_date_day-error"]')
      end

      it 'also links the fieldset to the contract_start_date_month error message' do
        render
        expect(rendered).to have_css('fieldset[aria-describedby~="contract_start_date_month-error"]')
      end

      it 'adds the message to the contract_start_date_month field' do
        render
        expect(rendered).to have_css('#contract_start_date_month-error.govuk-error-message', text: 'error-message')
      end

      it 'still adds error class to the contract_start_date_day field to highlight it' do
        render
        expect(rendered).to have_css('#contract_start_date_day.govuk-input--error')
      end

      it 'also adds error class to the contract_start_date_month field to highlight it' do
        render
        expect(rendered).to have_css('#contract_start_date_month.govuk-input--error')
      end
    end
  end

  context 'when the journey has an error in contract_start_date_month' do
    before do
      errors.add(:contract_start_date_month, 'error-message')
    end

    it 'adds error class to the contract_start_date_month field to highlight it' do
      render
      expect(rendered).to have_css('#contract_start_date_month.govuk-input--error')
    end
  end

  context 'when the journey has an error in contract_start_date_year' do
    before do
      errors.add(:contract_start_date_year, 'error-message')
    end

    it 'adds error class to the contract_start_date_year field to highlight it' do
      render
      expect(rendered).to have_css('#contract_start_date_year.govuk-input--error')
    end
  end

  context 'when the journey has an error in hire_date_day' do
    before do
      errors.add(:hire_date_day, 'error-message')
    end

    it 'links the fieldset to the error message' do
      render
      expect(rendered).to have_css('fieldset[aria-describedby="hire_date_day-error"]')
    end

    it 'displays the error summary' do
      render
      expect(rendered).to have_css('.govuk-error-summary')
    end

    it 'adds the form group error class' do
      render
      expect(rendered).to have_css('.govuk-form-group.govuk-form-group--error')
    end

    it 'adds the message to the field with the error' do
      render
      expect(rendered).to have_css('#hire_date_day-error.govuk-error-message', text: 'error-message')
    end

    it 'adds error class to the field in order to highlight it' do
      render
      expect(rendered).to have_css('#hire_date_day.govuk-input--error')
    end

    it 'adds an error prefix to the page title' do
      render
      expect(view.content_for(:page_title_prefix)).to match(t('layouts.application.error_prefix'))
    end

    context 'and the journey has an error in hire_date_month' do
      before do
        errors.add(:hire_date_month, 'error-message')
      end

      it 'still links the fieldset to the hire_date_day error message' do
        render
        expect(rendered).to have_css('fieldset[aria-describedby~="hire_date_day-error"]')
      end

      it 'also links the fieldset to the hire_date_month error message' do
        render
        expect(rendered).to have_css('fieldset[aria-describedby~="hire_date_month-error"]')
      end

      it 'adds the message to the hire_date_month field' do
        render
        expect(rendered).to have_css('#hire_date_month-error.govuk-error-message', text: 'error-message')
      end

      it 'still adds error class to the hire_date_day field to highlight it' do
        render
        expect(rendered).to have_css('#hire_date_day.govuk-input--error')
      end

      it 'also adds error class to the hire_date_month field to highlight it' do
        render
        expect(rendered).to have_css('#hire_date_month.govuk-input--error')
      end
    end
  end

  context 'when the journey has an error in hire_date_month' do
    before do
      errors.add(:hire_date_month, 'error-message')
    end

    it 'adds error class to the hire_date_month field to highlight it' do
      render
      expect(rendered).to have_css('#hire_date_month.govuk-input--error')
    end
  end

  context 'when the journey has an error in hire_date_year' do
    before do
      errors.add(:hire_date_year, 'error-message')
    end

    it 'adds error class to the hire_date_year field to highlight it' do
      render
      expect(rendered).to have_css('#hire_date_year.govuk-input--error')
    end
  end

  context 'when contract_start_date_day field was previously set' do
    before do
      step.contract_start_date_day = '01'
    end

    it 'sets the field to the previously entered value' do
      render
      expect(rendered).to have_field('contract_start_date_day', with: '01')
    end
  end

  context 'when contract_start_date_month field was previously set' do
    before do
      step.contract_start_date_month = '06'
    end

    it 'sets the field to the previously entered value' do
      render
      expect(rendered).to have_field('contract_start_date_month', with: '06')
    end
  end

  context 'when contract_start_date_year field was previously set' do
    before do
      step.contract_start_date_year = '2018'
    end

    it 'sets the field to the previously entered value' do
      render
      expect(rendered).to have_field('contract_start_date_year', with: '2018')
    end
  end

  context 'when hire_date_day field was previously set' do
    before do
      step.hire_date_day = '01'
    end

    it 'sets the field to the previously entered value' do
      render
      expect(rendered).to have_field('hire_date_day', with: '01')
    end
  end

  context 'when hire_date_month field was previously set' do
    before do
      step.hire_date_month = '06'
    end

    it 'sets the field to the previously entered value' do
      render
      expect(rendered).to have_field('hire_date_month', with: '06')
    end
  end

  context 'when hire_date_year field was previously set' do
    before do
      step.hire_date_year = '2018'
    end

    it 'sets the field to the previously entered value' do
      render
      expect(rendered).to have_field('hire_date_year', with: '2018')
    end
  end
end
