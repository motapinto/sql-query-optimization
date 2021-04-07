--------------------------------------------------------
--  Ref Constraints for Table YOCORRENCIAS
--------------------------------------------------------

  ALTER TABLE "UP201705205"."YOCORRENCIAS" ADD CONSTRAINT "YOCORRENCIAS_FKEY_YUCS" FOREIGN KEY ("CODIGO")
	  REFERENCES "UP201705205"."YUCS" ("CODIGO") ENABLE;
