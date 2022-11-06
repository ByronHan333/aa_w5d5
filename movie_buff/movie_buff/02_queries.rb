def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5
  # (inclusive). Show the id, title, year, and score.
  Movie
    .where("yr between 1980 and 1989")
    .where("score between 3 and 5")
    .select(:id, :title, :yr, :score)

end

def bad_years
  # List the years in which no movie with a rating above 8 was released.

  # works but hit twice
  # Movie
  #   .where("yr NOT IN (?)", Movie.where("score > 8").distinct.pluck(:yr))
  #   .distinct
  #   .pluck(:yr)

  Movie
    .group(:yr)
    # .having("SUM(score > 8) = 0")
    .having("MAX(score) <= 8")
    .pluck(:yr)

  # Movie
  #   .joins("LEFT JOIN movies above_8 ON above_8.yr = movies.yr AND above_8.score > 8 AND movies.score <= 8")
  #   .where("above_8.score > 8")
  #   .where("movies.score <= 8")
  #   .where("above_8.yr IS NULL")
  #   .distinct
  #   .pluck(:yr)



end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.

  # works
  # Actor
  #   .where("title = ?", title)
  #   .joins(:movies)
  #   .order("castings.ord ASC")
  #   .select(:id, :name)

  Movie
    .where("title = ?", title)
    .joins(:actors)
    .order("castings.ord ASC")
    .select("actors.id, actors.name")

end

def vanity_projects
  # List the title of all movies in which the director also appeared as the
  # starring actor. Show the movie id, title, and director's name.

  # Note: Directors appear in the 'actors' table.

  # Movie
  #   # .joins(:director)
  #   # .joins(:actors)
  #   .joins("INNER JOIN actors directors on movies.director_id = directors.id")
  #   .joins("LEFT JOIN castings c on movies.id=c.movie_id LEFT JOIN actors a on c.actor_id = a.id")
  #   .where("a.id = directors.id AND ord = 1")
  #   .select("movies.id", "movies.title", "directors.name")


  Movie
    .select(:id, :title, :name)
    .joins(:actors)
    .where('castings.ord = 1 AND movies.director_id = castings.actor_id')


end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name, and number of supporting roles.

  Actor
    .joins(:castings)
    .where.not("castings.ord = 1")
    .select(:id, :name, "COUNT(movie_id) as roles")
    .group("actors.id")
    .order("COUNT(movie_id) DESC")
    .limit(2)

end
