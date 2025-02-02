with
    user_avg_rating as (
        -- Calcular la puntuación media de cada usuario para cada juego
        select game_id, avg(user_rating) as avg_user_rating  -- Puntuación media del usuario en la escala 1-5
        from {{ ref("fct_game_sales") }}
        group by game_id
    )

select
    g.game_id,
    g.game_title,
    round(u.avg_user_rating, 2) as avg_user_rating,
    round((u.avg_user_rating * 2), 2) as avg_user_rating_scaled,
    g.shop_rating,
    round(abs(g.shop_rating - (u.avg_user_rating * 2)), 2) as rating_difference  -- Usamos ABS() para obtener la diferencia absoluta y redondeamos a 2 decimales
from user_avg_rating u
join {{ ref("dim_game") }} g on u.game_id = g.game_id
order by rating_difference
