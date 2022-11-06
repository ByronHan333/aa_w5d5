def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie
    .joins(:actors)
    .where("actors.name IN (?)", those_actors)
    .select(:title, "id")


end

def golden_age
  # Find the decade with the highest average movie score.
  # HINT: Use a movie's year to derive its decade. Remember that you can use
  # arithmetic expressions in SELECT clauses.
  # Movie
  #   .group("yr/10 * 10")
  #   .order("AVG(score) DESC")
  #   .limit(1)
  #   .select("yr/10 * 10 AS decade")

  # Movie.find_by_sql
  data = ActiveRecord::Base.connection.execute(<<-SQL)
    select yr/10 * 10 as decade
    from movies
    group by yr/10
    order by avg(score) desc
    limit 1
  SQL
  data[0]['decade']


end

def costars(name)
  # List the names of the actors that the named actor has ever appeared with.
  # Hint: use a subquery
  data = ActiveRecord::Base.connection.execute(<<-SQL, name)
    select distinct a2.name as names
    from actors a
    inner join castings c on a.id = c.actor_id
    inner join movies m on c.movie_id = m.id
    inner join castings c2 on m.id = c2.movie_id
    inner join actors a2 on a2.id = c2.actor_id
    where a.name = '#{name}'
    and a2.name != '#{name}'
  SQL
  data.map{|r| r['names']}


end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie.
  Actor
    .left_joins(:movies)
    .where("movies.id is NULL")
    .count

end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`. A name is
  # like whazzername if the actor's name contains all of the letters in
  # whazzername, ignoring case, in order.

  # E.g., "Sylvester Stallone" is like "sylvester" and "lester stone" but not
  # like "stallone sylvester" or "zylvester ztallone".


end

def longest_career
  # Find the 3 actors who had the longest careers (i.e., the greatest time
  # between first and last movie). Order by actor names. Show each actor's id,
  # name, and the length of their career.
  # Actor
  #   .joins(:movies)
  #   .group("actors.name")
  #   .order("MAX(yr)-MIN(yr) desc, actors.name")
  #   .select("actors.name, MAX(yr)-MIN(yr) AS career_length")
  #   .limit(3)

  data = ActiveRecord::Base.connection.execute(<<-SQL)
    select a.id, a.name, MAX(yr)-MIN(yr) AS career_length
    from actors a
    inner join castings c on a.id = c.actor_id
    inner join movies m on c.movie_id = m.id
    group by a.name, a.id
    order by MAX(yr)-MIN(yr) desc, a.name
    limit 3
  SQL
  data

end
