# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LivePoll.Repo.insert!(%LivePoll.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LivePoll.Repo

Repo.insert!(%LivePoll.Models.Category{name: "Food", description: "Esta categoria inclui uma variedade de alimentos, desde refeições prontas até ingredientes para cozinhar em casa. Pode abranger diferentes tipos de culinária, como pratos internacionais, comida rápida, alimentos saudáveis e sobremesas deliciosas."})

Repo.insert!(%LivePoll.Models.Category{name: "Anime", description: "Anime é uma forma de animação japonesa que abrange uma ampla gama de gêneros e estilos. Esta categoria engloba séries de anime, filmes e OVAs (Original Video Animations)."})

Repo.insert!(%LivePoll.Models.Category{name: "Movie", description: "Esta categoria abrange uma vasta gama de filmes de diferentes gêneros, como ação, drama, comédia, terror, ficção científica, fantasia, romance e documentários. Inclui longas-metragens de diversos países e épocas, desde clássicos do cinema até lançamentos contemporâneos."})

Repo.insert!(%LivePoll.Models.Category{name: "Game", description: "Esta categoria engloba uma ampla variedade de jogos eletrônicos, incluindo jogos para consoles, PC, dispositivos móveis e plataformas de realidade virtual. Pode incluir diferentes gêneros, como ação, aventura, RPG (Role-Playing Game), estratégia, simulação, quebra-cabeças, esportes, corrida, e muito mais."})

Repo.insert!(%LivePoll.Models.Category{name: "Book", description: "Engloba uma variedade de obras literárias, incluindo romances, ficção científica, fantasia, mistério, suspense, não ficção, biografias, autoajuda, poesia, entre outros gêneros."})
