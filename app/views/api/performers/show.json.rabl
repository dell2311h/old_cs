object @performer
attributes :id, :name
node(:picture_url) { |performer| performer.picture.url if performer.picture? }

extends 'api/shared/followable'

