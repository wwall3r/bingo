-- This script was generated by the Schema Diff utility in pgAdmin 4
-- For the circular dependencies, the order in which Schema Diff writes the objects is not very sophisticated
-- and may require manual changes to the script to ensure changes are applied in the correct order.
-- Please report an issue for any failure with the reproduction steps.

CREATE POLICY "game members can read"
    ON public.completions
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((id IN ( SELECT get_completions_for_user.completion_id
   FROM get_completions_for_user() get_completions_for_user(card_id, game_id, user_id, completion_id))));

CREATE POLICY "game members can read"
    ON public.cards_completions
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((card_id IN ( SELECT get_completions_for_user.card_id
   FROM get_completions_for_user() get_completions_for_user(card_id, game_id, user_id, completion_id))));

CREATE POLICY "game members can read"
    ON public.cards
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((id IN ( SELECT get_completions_for_user.card_id
   FROM get_completions_for_user() get_completions_for_user(card_id, game_id, user_id, completion_id))));
