module VideosHelper
  def textual_status_for(video)
    textual_statuses = {
      Video::STATUS_UPLOADING => I18n.t('descriptions.video.status.uploading'),
      Video::STATUS_NEW => I18n.t('descriptions.video.status.new'),
      Video::STATUS_IN_PROCESSING => I18n.t('descriptions.video.status.processing'),
      Video::STATUS_PROCESSING_DONE => I18n.t('descriptions.video.status.processing_done')
    }

    textual_statuses[video.status]
  end
end

