module SupplyTeachers
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      super(self.class.first_step_class, slug, params, paths)
    end

    def self.journey_name
      'supply-teachers'
    end

    def self.first_step_class
      LookingFor
    end

    def start_path
      supply_teachers_path
    end

    def next_step_path
      case next_slug
      when 'results'
        supply_teachers_branches_path(params: params)
      when 'master-vendor-managed-service'
        supply_teachers_master_vendors_path(journey: self.class.journey_name, params: params)
      when 'neutral-vendor-managed-service'
        supply_teachers_neutral_vendors_path(journey: self.class.journey_name, params: params)
      when 'calculate-temp-to-perm-fee'
        supply_teachers_temp_to_perm_fee_path(journey: self.class.journey_name, params: params)
      else
        super
      end
    end
  end
end
