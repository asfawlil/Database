-- This code creates 2 new tables from the existing ones in mondial to be able to update the data within them.
CREATE TABLE mycountry AS SELECT * FROM public.country;
CREATE TABLE myeconomy AS SELECT * FROM public.economy;