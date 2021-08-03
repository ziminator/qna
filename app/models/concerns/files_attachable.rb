module FilesAttachable
  extend ActiveSupport::Concern
  included do
    has_many_attached :files, dependent: :destroy
  end
end
