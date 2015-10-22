class HashtagParser < ActsAsTaggableOn::GenericParser
  def parse
    ActsAsTaggableOn::TagList.new.tap do |tag_list|
      tag_list.add Twitter::Extractor.extract_hashtags(@tag_list)
    end
  end
end
