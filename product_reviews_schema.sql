-- ============================================================
--  product_reviews — Supabase SQL Table
--  Run this in: Supabase Dashboard → SQL Editor
-- ============================================================

CREATE TABLE public.product_reviews (
  id            UUID                     DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id    TEXT                     NOT NULL,
  user_id       UUID                     NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name     TEXT                     NOT NULL,
  rating        SMALLINT                 NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment       TEXT                     NOT NULL CHECK (char_length(comment) >= 5),
  created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Index ──────────────────────────────────────────────────────────────────
CREATE INDEX idx_product_reviews_product_id
  ON public.product_reviews (product_id);

CREATE INDEX idx_product_reviews_user_id
  ON public.product_reviews (user_id);

-- ── Row Level Security ─────────────────────────────────────────────────────
ALTER TABLE public.product_reviews ENABLE ROW LEVEL SECURITY;

-- Everyone can read reviews
CREATE POLICY "reviews_select_all"
  ON public.product_reviews FOR SELECT
  USING (true);

-- Only authenticated users can insert their OWN reviews
CREATE POLICY "reviews_insert_own"
  ON public.product_reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update only their own reviews
CREATE POLICY "reviews_update_own"
  ON public.product_reviews FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete only their own reviews
CREATE POLICY "reviews_delete_own"
  ON public.product_reviews FOR DELETE
  USING (auth.uid() = user_id);

-- ── Helper view: rating summary per product ────────────────────────────────
CREATE OR REPLACE VIEW public.product_rating_summary AS
SELECT
  product_id,
  COUNT(*)::INT                                          AS total_reviews,
  ROUND(AVG(rating), 1)                                 AS average_rating,
  COUNT(*) FILTER (WHERE rating = 5)::INT               AS five_star,
  COUNT(*) FILTER (WHERE rating = 4)::INT               AS four_star,
  COUNT(*) FILTER (WHERE rating = 3)::INT               AS three_star,
  COUNT(*) FILTER (WHERE rating = 2)::INT               AS two_star,
  COUNT(*) FILTER (WHERE rating = 1)::INT               AS one_star
FROM public.product_reviews
GROUP BY product_id;

-- ── Trigger: Update product rating stats on new review ──────────────────────
CREATE OR REPLACE FUNCTION public.update_product_rating_stats()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    UPDATE public.products
    SET 
      rating = (SELECT average_rating FROM public.product_rating_summary WHERE product_id = NEW.product_id),
      review_count = (SELECT total_reviews FROM public.product_rating_summary WHERE product_id = NEW.product_id)
    WHERE id = NEW.product_id;
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    UPDATE public.products
    SET 
      rating = COALESCE((SELECT average_rating FROM public.product_rating_summary WHERE product_id = OLD.product_id), 0),
      review_count = COALESCE((SELECT total_reviews FROM public.product_rating_summary WHERE product_id = OLD.product_id), 0)
    WHERE id = OLD.product_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_product_rating
AFTER INSERT OR UPDATE OR DELETE ON public.product_reviews
FOR EACH ROW EXECUTE FUNCTION public.update_product_rating_stats();
