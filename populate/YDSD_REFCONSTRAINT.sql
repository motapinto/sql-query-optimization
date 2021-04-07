--------------------------------------------------------
--  Ref Constraints for Table YDSD
--------------------------------------------------------

  ALTER TABLE "UP201705205"."YDSD" ADD CONSTRAINT "YDSD_FKEY_YDOCENTES" FOREIGN KEY ("NR")
	  REFERENCES "UP201705205"."YDOCENTES" ("NR") ENABLE;
  ALTER TABLE "UP201705205"."YDSD" ADD CONSTRAINT "YDSD_FKEY_YTIPOSAULA" FOREIGN KEY ("ID")
	  REFERENCES "UP201705205"."YTIPOSAULA" ("ID") ENABLE;
