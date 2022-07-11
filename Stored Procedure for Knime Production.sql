/* Developed by:

https://github.com/metalhead13

*/

USE [Knime]
GO
/****** Object:  StoredProcedure [KNIME].[KNIME_PRODUCCION]    Script Date: 11/07/2022 1:36:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [KNIME].[KNIME_PRODUCCION] @PERIODO_CONTABLE INT
--drop PROCEDURE [DWH].[KNIME_PROD]
AS
BEGIN
		
	SELECT DISTINCT 
		(LTRIM(RTRIM(t1.RAMO_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA)) + '_' + LTRIM(RTRIM(FF_CERTIFICADO))) AS CLAVE_VIG
		,(LTRIM(RTRIM(t1.RAMO_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA)) + '_' + LTRIM(RTRIM(t1.CERTIFICADO)) + '_' + LTRIM(RTRIM(FF_CERTIFICADO))) AS CLAVE_VIG_CERT
		,(LTRIM(RTRIM(t1.SUCURSAL_PROD)) + '_' + LTRIM(RTRIM(t1.RAMO_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA)) + '_' + LTRIM(RTRIM(CERTIFICADO))) AS CLAVE
		,(LTRIM(RTRIM(t1.SUCURSAL_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA))) AS LLAVE
		,(LTRIM(RTRIM(t1.SUCURSAL_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA)) + '_' + LTRIM(RTRIM(CERTIFICADO))) AS LLAVE_RIESGO
		,t1.ANNO_CONTABLE
		,t1.MES_CONTABLE
		,t1.SUCURSAL_PROD
		,t1.RAMO_PROD
		,t1.POLIZA
		,t1.CERTIFICADO
		,t1.DOCUMENTO
		,t1.ANEXO
		,t1.SUCURSAL_EXPE
		--,t1.FI_CERTIFICADO
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FI_CERTIFICADO,112)),103) FI_CERTIFICADO
		,convert(DATETIME, convert(VARCHAR(10),t1.FI_CERTIFICADO,112)) FI_CERTIFICADO
		--,t1.FF_CERTIFICADO
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FF_CERTIFICADO,112)),103) FF_CERTIFICADO
		,convert(DATETIME, convert(VARCHAR(10),t1.FF_CERTIFICADO,112)) FF_CERTIFICADO
		--,t1.FI_ANEXO
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FI_ANEXO,112)),103) FI_ANEXO
		,convert(DATETIME, convert(VARCHAR(10),t1.FI_ANEXO,112)) FI_ANEXO
		--,t1.FF_ANEXO
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FF_ANEXO,112)),103) FF_ANEXO
		,convert(DATETIME, convert(VARCHAR(10),t1.FF_ANEXO,112)) FF_ANEXO
		--,t1.FI_DOCUMENTO
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FI_DOCUMENTO,112)),103) FI_DOCUMENTO
		,convert(DATETIME, convert(VARCHAR(10),t1.FI_DOCUMENTO,112)) FI_DOCUMENTO
		--,t1.FF_DOCUMENTO
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FF_DOCUMENTO,112)),103) FF_DOCUMENTO
		,convert(DATETIME, convert(VARCHAR(10),t1.FF_DOCUMENTO,112)) FF_DOCUMENTO
		--,t1.FECHA_EXPE
		--,convert(VARCHAR(10),convert(DATETIME, convert(VARCHAR(10),t1.FECHA_EXPE,112)),103) FECHA_EXPE
		,convert(DATETIME, convert(VARCHAR(10),t1.FECHA_EXPE,112)) FECHA_EXPE
		,t1.TIPO_POLIZA
		,t1.TIPO_TRANSAC
		,t1.COD_TRANSAC
		,t1.TIPO_IDENTIFI_TOM
		,t1.NRO_IDENTIFI_TOM
		,CAST(t1.NRO_IDENTIFI_TOM AS NUMERIC(15)) AS NRO_IDENTIFI_TOM_
		,t1.INTERMEDIARIO_LIDE
		,t1.CANAL
		,t1.VR_ASEG_POLIZA
		,t1.IND_OLEODUCTO
		,t1.COD_PRODUCTO
		,t1.COD_RAMO_SUSCRIP
		,t1.POLIZA_SUSCRIP
		,t1.CERTIFICADO_SUSCR
		,t1.TIPO_CONTRIB_TOM
		,t1.TIPO_PERSONA_TOM
		,t1.TIPO_DEBITO
		,t1.VR_PRIMA_PESOS
		,t1.COD_CIUDAD
		,t1.COD_DEPARTAMENTO
	INTO #T_PREMI_HEALTH_1
	FROM PROD.DWH_POLIZAS_H t1
	WHERE t1.PERIODO_CONTABLE<= @PERIODO_CONTABLE AND T1.PERIODO_CONTABLE>=(@PERIODO_CONTABLE-1000)
		  AND t1.RAMO_PROD IN ('10019','10020','10021','7452','7453','807','ADU','C1','C2',
							'C3','C4','CM','CX','D4','DX','F1','F2','FX','HC','HD','HE',
							'HF','HM','I1','I2','I3','I4','IM','IX','LMP','O10','O11','O12',
							'O13','RDH','S2','S3','SA','SC','SE','SI','SS','T1','T2','T4','TX',
							'Z1','Z2','ACS','CAN','CCP','E1','E3','E5','E6','E7','F3','H1','H2',
							'H4','SE','Z3','Z4','Z5','Z6','Z7','Z8')
	
	
	
	UPDATE #T_PREMI_HEALTH_1
	SET FI_DOCUMENTO = dateadd(day, -(CASE WHEN DATEPART(MONTH,FF_DOCUMENTO) = 3 AND DATEPART(YEAR,FF_DOCUMENTO) IN (2008,2012,2016,2020,2024) THEN 29 ELSE
									   CASE WHEN DATEPART(MONTH,FF_DOCUMENTO) = 3 AND DATEPART(YEAR,FF_DOCUMENTO) NOT IN (2008,2012,2016,2020,2024) THEN 28 ELSE
									   CASE WHEN DATEPART(MONTH,FF_DOCUMENTO) IN (5,7,10,12) THEN 30 ELSE
									   CASE WHEN DATEPART(MONTH,FF_DOCUMENTO) IN (1,2,4,6,8,9,11) THEN 31 END END END END), FF_DOCUMENTO)
	WHERE RAMO_PROD='E1' 
	AND POLIZA in (91212756,91207853,91212630,91212438,91212621,91212762) 
	AND FI_DOCUMENTO = FF_DOCUMENTO
	
	UPDATE #T_PREMI_HEALTH_1
	SET FF_DOCUMENTO = FF_CERTIFICADO
	WHERE FI_DOCUMENTO = FF_DOCUMENTO
	
	UPDATE #T_PREMI_HEALTH_1
	SET FI_DOCUMENTO = FI_CERTIFICADO
	WHERE FI_DOCUMENTO = FF_DOCUMENTO
	AND FF_DOCUMENTO = FF_CERTIFICADO
	
	UPDATE #T_PREMI_HEALTH_1
	SET FF_DOCUMENTO = FF_CERTIFICADO
	WHERE FI_DOCUMENTO = FF_DOCUMENTO
	
	UPDATE #T_PREMI_HEALTH_1
	SET FF_DOCUMENTO = dateadd(day, 1, FF_DOCUMENTO)
	WHERE FI_DOCUMENTO = FF_DOCUMENTO
	
	
	
	SELECT-- TOP 10000
		(LTRIM(RTRIM(t1.SUCURSAL_PROD)) + '_' + LTRIM(RTRIM(t1.RAMO_PROD)) + '_' + LTRIM(RTRIM(POLIZA)) + '_' + LTRIM(RTRIM(CERTIFICADO))) AS CLAVE
		,(LTRIM(RTRIM(t1.SUCURSAL_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA)) + '_' + LTRIM(RTRIM(t1.RAMO_PROD)) + '_' + LTRIM(RTRIM(t1.POLIZA)) + '_' + LTRIM(RTRIM(t1.CERTIFICADO))+ '_' + LTRIM(RTRIM(t1.FF_VIG_ASEG))) AS CLAVE_VIG
		,(LTRIM(RTRIM(t1.ANNO_CONTABLE)) + '_' + LTRIM(RTRIM(t1.MES_CONTABLE))) AS PER_CONT
		,'HEL' AS SBU
		,t1.*
	--INTO WORK.T_ASEG_HEALTH_1
	INTO #T_ASEG_HEALTH_1
	FROM  PROD.DWH_POL_ASEG_H t1
	WHERE t1.PERIODO_CONTABLE<= @PERIODO_CONTABLE AND T1.PERIODO_CONTABLE>= (@PERIODO_CONTABLE-1000)
		  AND t1.RAMO_PROD IN ('10019','10020','10021','7452','7453','807','ADU','C1','C2',
							'C3','C4','CM','CX','D4','DX','F1','F2','FX','HC','HD','HE',
							'HF','HM','I1','I2','I3','I4','IM','IX','LMP','O10','O11','O12',
							'O13','RDH','S2','S3','SA','SC','SE','SI','SS','T1','T2','T4','TX',
							'Z1','Z2','ACS','CAN','CCP','E1','E3','E5','E6','E7','F3','H1','H2',
							'H4','SE','Z3','Z4','Z5','Z6','Z7','Z8')
	


	SELECT DISTINCT t1.CLAVE, 
	--SELECT TOP 1000000 t1.CLAVE, 
	t1.SBU, 
	t1.SUCURSAL_PROD, 
	t1.RAMO_PROD, 
	t1.POLIZA, 
	t1.CERTIFICADO, 
	t1.NRO_UNICO_ASEG, 
	t1.TIPO_IDENTIFI_ASEG, 
	t1.NRO_IDENTIFI_ASEG, 
	t1.IND_ASEG_PPAL, 
	t1.TIPO_PERSONA, 
	--t1.FECHA_NACIMIENTO, 
	convert(DATETIME, convert(VARCHAR(10),t1.FECHA_NACIMIENTO,112)) FECHA_NACIMIENTO,
	t1.SEXO, 
	t1.EST_CIVIL, 
	t1.COD_DEPARTAMENTO, 
	t1.COD_CIUDAD, 
	t1.EPS
	INTO #T_ASEG_HEALTH_2
	FROM #T_ASEG_HEALTH_1 t1
	
	IF OBJECT_ID ('KNIME.T_PREMI_HEALTH_2') IS NOT NULL DROP TABLE KNIME.T_PREMI_HEALTH_2
			
	CREATE TABLE KNIME.T_PREMI_HEALTH_2
	(
		id INT IDENTITY,
		CLAVE_VIG VARCHAR (32),
		CLAVE_VIG_CERT VARCHAR (45),
		CLAVE VARCHAR (45),
		LLAVE VARCHAR (25),
		LLAVE_RIESGO VARCHAR (38),
		ANNO_CONTABLE INT,
		MES_CONTABLE INT,
		VR_PRIMA_PESOS DECIMAL (20, 2),
		FF_DOCUMENTO DATETIME,
		FI_DOCUMENTO DATETIME,
		TIPO_TRANSAC INT,
		VR_ASEG_POLIZA DECIMAL (15, 2),
		COD_TRANSAC INT
	)	
	
	INSERT INTO KNIME.T_PREMI_HEALTH_2
	SELECT CLAVE_VIG, CLAVE_VIG_CERT, CLAVE, LLAVE, LLAVE_RIESGO, ANNO_CONTABLE, MES_CONTABLE, VR_PRIMA_PESOS, FF_DOCUMENTO, FI_DOCUMENTO, TIPO_TRANSAC,VR_ASEG_POLIZA, COD_TRANSAC
	--INTO KNIME.T_PREMI_HEALTH_2
	FROM #T_PREMI_HEALTH_1
	
	CREATE INDEX idx_p ON KNIME.T_PREMI_HEALTH_2(ID)
	
	TRUNCATE TABLE KNIME.EXP_M
	TRUNCATE TABLE KNIME.DEV_M
	TRUNCATE TABLE KNIME.EMI_M
	TRUNCATE TABLE KNIME.VEASEG_M
	
	DECLARE @sql nvarchar(2000);
	DECLARE @c varchar(30);
	SET @c = 1;
	
	WHILE @c <= 84
	BEGIN
		
		SELECT @sql = 'INSERT INTO KNIME.EXP_M'
		SELECT @sql =  @sql + ' SELECT a.id, '+ convert(VARCHAR(2),@c) +', convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365 AS calc'
		SELECT @sql =  @sql + ' FROM #T_PREMI_HEALTH_2 a, TEMP.APOYO.FECHAS_PARAMETRICAS b'
		SELECT @sql =  @sql + ' WHERE b.id = '+ convert(VARCHAR(2),@c)
		SELECT @sql =  @sql + ' AND TIPO_TRANSAC IN (1,2,9)'
		SELECT @sql =  @sql + ' AND (convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365) <> 0'
		EXEC (@sql)
	
		SELECT @sql = 'INSERT INTO KNIME.EXP_M'
		SELECT @sql =  @sql + ' SELECT a.id, '+ convert(VARCHAR(2),@c) +', convert(NUMERIC(16,2),-datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365 AS calc'
		SELECT @sql =  @sql + ' FROM #T_PREMI_HEALTH_2 a, TEMP.APOYO.FECHAS_PARAMETRICAS b'
		SELECT @sql =  @sql + ' WHERE b.id = '+ convert(VARCHAR(2),@c)
		SELECT @sql =  @sql + ' AND (TIPO_TRANSAC IN (4,12) or (TIPO_TRANSAC = 8 AND COD_TRANSAC = 21))'
		SELECT @sql =  @sql + ' AND (convert(NUMERIC(16,2),-datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365) <> 0'
		EXEC (@sql)
	
		SELECT @sql = 'INSERT INTO KNIME.DEV_M'
		SELECT @sql =  @sql + ' SELECT a.id, '+ convert(VARCHAR(2),@c) +', VR_PRIMA_PESOS * convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / datediff(day,fi_documento,ff_documento) AS calc'
		SELECT @sql =  @sql + ' FROM #T_PREMI_HEALTH_2 a, TEMP.APOYO.FECHAS_PARAMETRICAS b'
		SELECT @sql =  @sql + ' WHERE b.id = '+ convert(VARCHAR(2),@c)
		SELECT @sql =  @sql + ' AND (VR_PRIMA_PESOS * convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / (datediff(day,fi_documento,ff_documento))) <> 0'
		EXEC (@sql)
	   
		SELECT @sql = 'INSERT INTO KNIME.EMI_M'
		SELECT @sql =  @sql + ' SELECT a.id, '+ convert(VARCHAR(2),@c) +', VR_PRIMA_PESOS'
		SELECT @sql =  @sql + ' FROM #T_PREMI_HEALTH_2 a, TEMP.APOYO.FECHAS_PARAMETRICAS b'
		SELECT @sql =  @sql + ' WHERE b.id = '+ convert(VARCHAR(2),@c)
		SELECT @sql =  @sql + ' AND (anno_contable * 100 + mes_contable) = b.MES'
		EXEC (@sql)
	
		SELECT @sql = 'INSERT INTO KNIME.VEASEG_M'
		SELECT @sql =  @sql + ' SELECT a.id, '+ convert(VARCHAR(2),@c) +', VR_ASEG_POLIZA * convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365 AS calc'
		SELECT @sql =  @sql + ' FROM #T_PREMI_HEALTH_2 a, TEMP.APOYO.FECHAS_PARAMETRICAS b'
		SELECT @sql =  @sql + ' WHERE b.id = '+ convert(VARCHAR(2),@c)
		SELECT @sql =  @sql + ' AND TIPO_TRANSAC IN (1,2,9)'
		SELECT @sql =  @sql + ' AND (VR_ASEG_POLIZA * convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365) <> 0'
		EXEC (@sql)
		
		SELECT @sql = 'INSERT INTO KNIME.VEASEG_M'
		SELECT @sql =  @sql + ' SELECT a.id, '+ convert(VARCHAR(2),@c) +', -VR_ASEG_POLIZA * convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365 AS calc'
		SELECT @sql =  @sql + ' FROM #T_PREMI_HEALTH_2 a, TEMP.APOYO.FECHAS_PARAMETRICAS b'
		SELECT @sql =  @sql + ' WHERE b.id = '+ convert(VARCHAR(2),@c)
		SELECT @sql =  @sql + ' AND (TIPO_TRANSAC IN (4,12) or (TIPO_TRANSAC = 8 AND COD_TRANSAC = 21))'
		SELECT @sql =  @sql + ' AND (-VR_ASEG_POLIZA * convert(NUMERIC(16,2),datediff(day,(SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), ((SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), (a.fi_documento)) AS UNIQUECOLUMN(filaMaxima)))) AS UNIQUECOLUMN(filaMinima)),'
		SELECT @sql =  @sql + ' (SELECT max(filaMaxima) FROM (VALUES (b.fecha_inicio), ((SELECT min(filaMinima) FROM (VALUES (b.fecha_fin), (a.ff_documento)) AS UNIQUECOLUMN(filaMinima)))) AS UNIQUECOLUMN(filaMaxima)))) / 365) <> 0'
		EXEC (@sql)
	
		SELECT @c = @c + 1
	END
	/*
	SELECT 
	 (SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (1,2,3,4,5,6,7,8,9,10,11,12)) AS EXP_M_12
	,(SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (13,14,15,16,17,18,19,20,21,22,23,24)) AS EXP_M_24
	,(SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (25,26,27,28,29,30,31,32,33,34,35,36)) AS EXP_M_36
	,(SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (37,38,39,40,41,42,43,44,45,46,47,48)) AS EXP_M_48
	,(SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (48,49,50,51,52,53,54,56,57,58,59,60)) AS EXP_M_60
	,(SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (61,62,63,64,65,66,67,68,69,70,71,72)) AS EXP_M_72
	,(SELECT isnull(sum(calc),0) FROM KNIME.EXP_M WHERE id_c IN (73,74,75,76,77,78,79,80,81,82,83,84)) AS EXP_M_84
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (1,2,3,4,5,6,7,8,9,10,11,12)) AS EMI_M_12
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (13,14,15,16,17,18,19,20,21,22,23,24)) AS EMI_M_24
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (25,26,27,28,29,30,31,32,33,34,35,36)) AS EMI_M_36
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (37,38,39,40,41,42,43,44,45,46,47,48)) AS EMI_M_48
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (48,49,50,51,52,53,54,56,57,58,59,60)) AS EMI_M_60
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (61,62,63,64,65,66,67,68,69,70,71,72)) AS EMI_M_72
	,(SELECT isnull(sum(calc),0) FROM KNIME.EMI_M WHERE id_c IN (73,74,75,76,77,78,79,80,81,82,83,84)) AS EMI_M_84
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (1,2,3,4,5,6,7,8,9,10,11,12)) AS DEV_M_12
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (13,14,15,16,17,18,19,20,21,22,23,24)) AS DEV_M_24
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (25,26,27,28,29,30,31,32,33,34,35,36)) AS DEV_M_36
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (37,38,39,40,41,42,43,44,45,46,47,48)) AS DEV_M_48
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (48,49,50,51,52,53,54,56,57,58,59,60)) AS DEV_M_60
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (61,62,63,64,65,66,67,68,69,70,71,72)) AS DEV_M_72
	,(SELECT isnull(sum(calc),0) FROM KNIME.DEV_M WHERE id_c IN (73,74,75,76,77,78,79,80,81,82,83,84)) AS DEV_M_84
	INTO #A
	
	SELECT '' as A
		  ,(SUM(isnull(t1.EXP_M_12,0))) AS EXP_M_12 
		  ,(SUM(isnull(t1.EXP_M_24,0))) AS EXP_M_24 
		  ,(SUM(isnull(t1.EXP_M_36,0))) AS EXP_M_36 
		  ,(SUM(isnull(t1.EXP_M_48,0))) AS EXP_M_48 
		  ,(SUM(isnull(t1.EXP_M_60,0))) AS EXP_M_60 
		  ,(SUM(isnull(t1.EXP_M_72,0))) AS EXP_M_72 
		  ,(SUM(isnull(t1.EXP_M_84,0))) AS EXP_M_84 
	FROM #A t1
	
	
	SELECT '' as A
		  ,(SUM(isnull(t1.EMI_M_12,0))) AS EMI_M_12 
		  ,(SUM(isnull(t1.EMI_M_24,0))) AS EMI_M_24 
		  ,(SUM(isnull(t1.EMI_M_36,0))) AS EMI_M_36 
		  ,(SUM(isnull(t1.EMI_M_48,0))) AS EMI_M_48 
		  ,(SUM(isnull(t1.EMI_M_60,0))) AS EMI_M_60 
		  ,(SUM(isnull(t1.EMI_M_72,0))) AS EMI_M_72 
		  ,(SUM(isnull(t1.EMI_M_84,0))) AS EMI_M_84 
	FROM #A t1
	
	SELECT '' as A
		  ,(SUM(isnull(t1.DEV_M_12,0))) AS DEV_M_12 
		  ,(SUM(isnull(t1.DEV_M_24,0))) AS DEV_M_24 
		  ,(SUM(isnull(t1.DEV_M_36,0))) AS DEV_M_36 
		  ,(SUM(isnull(t1.DEV_M_48,0))) AS DEV_M_48 
		  ,(SUM(isnull(t1.DEV_M_60,0))) AS DEV_M_60 
		  ,(SUM(isnull(t1.DEV_M_72,0))) AS DEV_M_72 
		  ,(SUM(isnull(t1.DEV_M_84,0))) AS DEV_M_84 
	FROM #A t1
	
	
	SELECT
	       ANNO_CONTABLE
		  ,(SUM(VR_PRIMA_PESOS)) AS EMI
	FROM  #T_PREMI_HEALTH_1 t1
	GROUP BY ANNO_CONTABLE
	ORDER BY ANNO_CONTABLE DESC
*/
END


/* Developed by:

https://github.com/metalhead13

*/