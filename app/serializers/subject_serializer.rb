class SubjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :headline, :description, :featured, :thumbnail_url, :banner_url, :liked

  def liked
    scope ? true : false
  end
end
