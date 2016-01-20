module VotesHelper
  def votes_size(votes, total_votes)
    if votes.to_f/total_votes > 0.75
      return "vote-size-biggest"
    elsif votes.to_f/total_votes > 0.50
      return "vote-size-big"
    elsif votes.to_f/total_votes > 0.30
      return "vote-size-medium"
    elsif votes.to_f/total_votes > 0.15
      return "vote-size-small"
    else
      return "vote-size-smallest"
    end
  end
end
