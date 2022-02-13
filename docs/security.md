# Permissions

## Games

| Action                                  | Requirement                                      | Notes                                                                                                                                                              |
| --------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Create a game                           | A user has an available credit                   | The credit idea is prevent unlimited game creation / abuse of the API                                                                                              |
| Update a game                           | A user has an available credit                   |                                                                                                                                                                    |
| Invite a user to a game                 | owner or keeper role                             | This also needs to be rate limited so there is not API abuse.                                                                                                      |
| Create a board                          | member of game                                   | One board per user                                                                                                                                                 |
| View a board                            | member of game                                   |                                                                                                                                                                    |
| Update a board (add/remove completions) | owner of board, or owner of game, keeper of game |                                                                                                                                                                    |
| Assign game role                        | owner of board                                   | This is a little problematic from the API perspective as there are multiple roles that can be set. An owner should only be able to apply the player or keeper role |

## System

| Action               | Requirement             | Notes                         |
| -------------------- | ----------------------- | ----------------------------- |
| Request new role     | any authenticated user  | Need to check re-request      |
| Propose an objective | editor role, admin role | Editors are based on requests |
| Enable an objective  | admin role              |                               |
| Disable an objective | admin role              |                               |
| Propose a tag        | editor role, admin role |                               |
| Enable a tag         | admin role              |                               |
| Disable a tag        | admin role              |                               |

# Security concerns

- Inappropriate text: foul language, slurs, nsfw, etc.
- API abuse: Denial of service
- SQL Injection
