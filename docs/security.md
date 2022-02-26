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

# RLS Options

Doing some research, there are different strategies for doing complex RLS with multiple readers and writers

## RLS in the row

This strategy puts all the information in the row.

**Columns**

- owner: column_type ID of the user that has full control of the record
- writers: column_type array of IDs (a foreign key cannot be enforced)
- readers: column_type array of IDs (a foreign key cannot be enforced)

**Constraints**

- create/insert: depends on system requirements
- read: if ID is owner or in readers column
- update: if ID is owner or in the writers column
- delete: if ID is owner
  If this pattern is followed throughout a single procedure could be used through the database.

**Benefits**:

- One stop shopping.
- Easily understood.

**Drawbacks**:

- Large numbers of readers & writers in the arrays make for bloated roles.
- There is no foreign key relationships.
- Searching the table by readers or writers uses a little different syntax: https://stackoverflow.com/a/54069718 and a table index might not be available (but you can index the values in the cell): https://stackoverflow.com/a/4059785

## RLS in a PERMISSIONS table

This strategy puts all the security information in a single table as single entries. Consider moving this out of the public schema and only be accessed by system procedures or triggers.

**Columns**

- target id: column_type ID the row id under protection
- permission: enumeration (or maybe follow the unix pattern rwx)
- granted_to: column_tye ID the identifier for a group / profile / user

**Constraints**

- create/insert: depends on system requirements
- read: if ID is granted_to and permission is 'r'
- update: if ID is granted_to and permission is 'w'
- delete: if ID is granted_to and permission is 'w'

If this pattern is followed throughout a single constraint procedure could be used through the database.

**Benefits**:

- Almost one-stop shopping.A single permissions table for all permissions.
- Flexible - could use user ids or group ids if foreign keys are not used.
- Possible referential integrity if using a separate column for users and groups
- A single procedure could be used for checking permissions.

**Drawbacks**:

- Table is going to get big.
- There is no foreign key relationships

## RLS in a USERs table

The puts all the permissions a user has into a single row in a users table. This is a model that Khan Academy uses according to the changelog podcast: https://podbay.fm/p/go-time/e/1645723200

**Columns**
There are a lot of columns in this implementation. Roughly one per table that a user can interact with.

- table_name_read: array of records that can be read
- table_name_write: array of records that can be updated

**Constraints**

- read: if ID is in the table_name_read
- update: if ID is in the table_name_write
- delete: if ID is in the table_name write

If this pattern is followed throughout a single constraint procedure could be used through the database.

**Benefits**:

- One-stop shopping. Get all user permissions with a single direct access.
- No complex joins.
- Dovetails into a 'credits' system for inserting objects in the db

**Drawbacks**:

- Need to create a column for each table
- Going to need triggers to clean up the records on inserts and deletes
- There is no foreign key relationships break down by using arrays.
