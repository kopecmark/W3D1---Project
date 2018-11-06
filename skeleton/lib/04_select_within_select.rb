# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# A note on subqueries: we can refer to values in the outer SELECT within the
# inner SELECT. We can name the tables so that we can tell the difference
# between the inner and outer versions.

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
    SELECT
      rest.name
    FROM
      countries AS rest
    WHERE
      rest.population > (
        SELECT
          russia.population
          FROM
            countries AS russia
          WHERE
            russia.name = 'Russia'
          )
  SQL
end

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
  SELECT rest.name
  FROM countries AS rest
  WHERE continent = 'Europe'
  AND (rest.gdp / rest.population) > (
    SELECT uk.gdp / uk.population
    FROM countries AS uk
    WHERE uk.name = 'United Kingdom'
)
  SQL
end

def neighbors_of_certain_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
    SELECT other.name, other.continent
    FROM countries AS other
    WHERE other.continent IN (
      SELECT bb.continent
      FROM countries AS bb
      WHERE bb.name IN ('Belize', 'Belgium')
  )
    SQL
end

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland? Show the name and the population.
  execute(<<-SQL)
    SELECT
     countries.name,
     countries.population
    FROM
     countries
    WHERE
     countries.population > (
       SELECT
         canada.population
       FROM
         countries canada
       WHERE
         canada.name = 'Canada'
     )
     AND countries.population < (
       SELECT
         poland.population
       FROM
         countries poland
       WHERE
         poland.name = 'Poland'
     )
  SQL
end

def sparse_continents
  # Find every country that belongs to a continent where each country's
  # population is less than 25,000,000. Show name, continent and
  # population.
  # Hint: Sometimes rewording the problem can help you see the solution.
  execute(<<-SQL)
    SELECT countries.name, countries.continent, countries.population
    FROM countries
    WHERE countries.continent NOT IN (
      SELECT c2.continent
      FROM countries AS c2
      WHERE c2.population >= 25000000
    )
  SQL
end
