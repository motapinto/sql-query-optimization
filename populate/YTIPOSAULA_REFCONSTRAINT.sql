--------------------------------------------------------
--  Ref Constraints for Table YTIPOSAULA
--------------------------------------------------------

  ALTER TABLE "UP201705205"."YTIPOSAULA" ADD CONSTRAINT "YTIPOSAULA_FKEY_YOCORRENCIAS_ANOLETIVO" FOREIGN KEY ("CODIGO", "ANO_LETIVO", "PERIODO")
	  REFERENCES "UP201705205"."YOCORRENCIAS" ("CODIGO", "ANO_LETIVO", "PERIODO") ENABLE;
