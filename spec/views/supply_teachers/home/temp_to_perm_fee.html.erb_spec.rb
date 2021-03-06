require 'rails_helper'

RSpec.describe 'supply_teachers/home/temp_to_perm_fee.html.erb' do
  include_context 'with friendly dates'

  let(:contract_start_date) { start_of_1st_week }
  let(:hire_date) { nil }
  let(:day_rate) { 110 }
  let(:markup_rate) { 0.1 }
  let(:days_per_week) { 5 }
  let(:notice_date) { nil }

  let(:i18n_key) { 'supply_teachers.home.temp_to_perm_fee' }

  let(:calculator) do
    options = {
      day_rate: day_rate,
      days_per_week: days_per_week,
      contract_start_date: contract_start_date,
      hire_date: hire_date,
      markup_rate: markup_rate,
      notice_date: notice_date
    }
    TempToPermCalculator::Calculator.new(options)
  end

  before do
    assign(:calculator, calculator)
  end

  describe 'national deal explanation' do
    let(:paragraph_string) { /before the National Deal was awarded/ }
    let(:hire_date) { Time.zone.today }

    context 'when contract start date is before national deal began' do
      let(:contract_start_date) { Date.parse('2018-08-22') }

      before do
        render
      end

      it 'displays explanatory text' do
        expect(rendered).to have_text(paragraph_string)
      end
    end

    context 'when contract start date is after national deal began' do
      let(:contract_start_date) { Date.parse('2018-08-23') }

      before do
        render
      end

      it 'displays explanatory text' do
        expect(rendered).not_to have_text(paragraph_string)
      end
    end
  end

  describe 'irrespective of hire date' do
    let(:hire_date) { Time.zone.today }

    it 'explains the circumstances under which you can avoid paying the supplier a fee for taking on a worker permanently' do
      render
      expect(rendered).to have_text(/There is no fee to make a temporary member of staff permanent as long as/)
    end
  end

  context 'when hiring after 12 weeks' do
    let(:hire_date) { start_of_13th_week }

    context 'and giving enough notice' do
      let(:notice_date) { start_of_9th_week }

      before do
        render
      end

      it 'displays explanation' do
        expect(rendered).to have_text(I18n.t("#{i18n_key}.after_12_weeks_and_enough_notice"))
      end

      it 'does not explain how to avoid paying fees' do
        expect(rendered).not_to render_template('_avoid_paying_fees')
      end
    end

    context 'and not giving enough notice' do
      let(:notice_date) { start_of_12th_week }

      before do
        render
      end

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.after_12_weeks_and_not_enough_notice", fee: '£50.00')
        )
      end

      it 'displays note about negotiable fees' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.fees_are_negotiable")
        )
      end

      it 'displays notice period required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_required", days: 20)
        )
      end

      it 'displays notice period given' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_given",
                 days: 5,
                 notice_date: 'Monday 19 November 2018',
                 hire_date: 'Monday 26 November 2018')
        )
      end

      it 'displays chargeable days for lack of notice' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.lack_of_notice_chargeable_days", count: 15)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£150.00')
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end

      context 'and the worker works fewer than 5 days a week' do
        let(:days_per_week) { 2 }

        it 'displays pro rata daily supplier fee' do
          expect(rendered).to have_text(
            I18n.t("#{i18n_key}.daily_supplier_fee_pro_rata", fee: '£4.00', days_per_week: 2)
          )
        end
      end
    end

    context 'and not entering a notice date' do
      let(:notice_date) { nil }

      before do
        render
      end

      it 'displays the minimum and maximum fees that could be charged by the supplier' do
        expect(rendered).to have_text(/you could be charged\n +between £0 and £200/)
      end

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.after_12_weeks_and_no_notice_date")
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end

      context 'and the worker works fewer than 5 days a week' do
        let(:days_per_week) { 2 }

        it 'displays explanation' do
          expect(rendered).to have_text(
            I18n.t("#{i18n_key}.after_12_weeks_and_no_notice_date")
          )
        end
      end
    end
  end

  context 'when hiring between 9 and 12 weeks' do
    let(:hire_date) { start_of_11th_week }

    before do
      render
    end

    context 'and giving enough notice' do
      let(:notice_date) { start_of_7th_week }

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.between_9_and_12_weeks_and_enough_notice")
        )
      end

      it 'displays note about negotiable fees' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.fees_are_negotiable")
        )
      end

      it 'displays the number of working days required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days_required")
        )
      end

      it 'displays the number of working days between contract start and hire date' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days",
                 days: 50,
                 contract_start_date: 'Monday 03 September 2018',
                 hire_date: 'Monday 12 November 2018')
        )
      end

      it 'displays the days chargeable for early-hire' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.early_hire_chargeable_days", count: 10)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£100.00')
        )
      end

      context 'and the worker works fewer than 5 days a week' do
        let(:days_per_week) { 2 }

        it 'displays pro rata daily supplier fee' do
          expect(rendered).to have_text(
            I18n.t("#{i18n_key}.daily_supplier_fee_pro_rata", fee: '£4.00', days_per_week: 2)
          )
        end
      end
    end

    context 'and not giving enough notice' do
      let(:notice_date) { start_of_10th_week }

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.between_9_and_12_weeks_and_not_enough_notice")
        )
      end

      it 'displays note about negotiable fees' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.fees_are_negotiable")
        )
      end

      it 'displays the number of working days required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days_required")
        )
      end

      it 'displays the number of working days between contract start and hire date' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days",
                 days: 50,
                 contract_start_date: 'Monday 03 September 2018',
                 hire_date: 'Monday 12 November 2018')
        )
      end

      it 'displays the days chargeable for early-hire' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.early_hire_chargeable_days", count: 10)
        )
      end

      it 'displays notice period required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_required", days: 20)
        )
      end

      it 'displays notice period given' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_given",
                 days: 5,
                 notice_date: 'Monday 05 November 2018',
                 hire_date: 'Monday 12 November 2018')
        )
      end

      it 'displays chargeable days for lack of notice' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.lack_of_notice_chargeable_days", count: 15)
        )
      end

      it 'displays total chargeable days' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_chargeable_days",
                 days: 20)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£200.00')
        )
      end

      context 'and the worker works fewer than 5 days a week' do
        let(:days_per_week) { 2 }

        it 'displays pro rata daily supplier fee' do
          expect(rendered).to have_text(
            I18n.t("#{i18n_key}.daily_supplier_fee_pro_rata", fee: '£4.00', days_per_week: 2)
          )
        end
      end
    end

    context 'and not entering a notice date' do
      let(:notice_date) { nil }

      it 'displays the minimum and maximum fees that could be charged by the supplier' do
        expect(rendered).to have_text(/you could be charged\n +between £100\.00 and £200\.00/)
      end

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.between_9_and_12_weeks_and_no_notice_date")
        )
      end

      it 'displays note about negotiable fees' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.fees_are_negotiable")
        )
      end

      it 'displays the number of working days required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days_required")
        )
      end

      it 'displays the number of working days between contract start and hire date' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days",
                 days: 50,
                 contract_start_date: 'Monday 03 September 2018',
                 hire_date: 'Monday 12 November 2018')
        )
      end

      it 'displays the days chargeable for early-hire' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.early_hire_chargeable_days", count: 10)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£100.00')
        )
      end

      it 'displays disclaimer about not giving enough notice' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_disclaimer",
                 max_fee: '£200.00',
                 latest_notice_date: 'Monday 15 October 2018')
        )
      end

      context 'and the worker works fewer than 5 days a week' do
        let(:days_per_week) { 2 }

        it 'displays pro rata daily supplier fee' do
          expect(rendered).to have_text(
            I18n.t("#{i18n_key}.daily_supplier_fee_pro_rata", fee: '£4.00', days_per_week: 2)
          )
        end
      end

      context 'and the fee has reached the maximum fee that can be charged in this period' do
        let(:hire_date) { start_of_9th_week }

        it 'displays a single fee in the heading' do
          expect(rendered).to have_text(/you could be charged\n +£200/)
        end

        it 'does not display the disclaimer about not giving enough notice' do
          expect(rendered).not_to have_text(/You may be charged more than the fee displayed/)
        end
      end
    end
  end

  context 'when hiring within the first 8 weeks' do
    let(:hire_date) { start_of_8th_week }

    before do
      render
    end

    it 'displays explanation' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.within_first_8_weeks")
      )
    end

    it 'displays note about negotiable fees' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.fees_are_negotiable")
      )
    end

    it 'displays the number of working days required' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.working_days_required")
      )
    end

    it 'displays the number of working days between contract start and hire date' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.working_days",
               days: 35,
               contract_start_date: 'Monday 03 September 2018',
               hire_date: 'Monday 22 October 2018')
      )
    end

    it 'displays the days chargeable for early-hire' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.early_hire_chargeable_days", count: 25)
      )
    end

    it 'displays supplier daily fee' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
      )
    end

    it 'displays total fee' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.total_fee", fee: '£250.00')
      )
    end

    context 'and the worker works fewer than 5 days a week' do
      let(:days_per_week) { 2 }

      it 'displays pro rata daily supplier fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee_pro_rata", fee: '£4.00', days_per_week: 2)
        )
      end
    end
  end
end
