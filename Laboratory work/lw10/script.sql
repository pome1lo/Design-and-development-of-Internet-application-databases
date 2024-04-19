-- 1. Создание отдельного табличного пространства для хранения LOB
CREATE TABLESPACE lob_data
  DATAFILE 'C:\XEPDB1\lw10\PDB\lob_data.dbf' SIZE 100M
  AUTOEXTEND ON;

-- 2 = C:\XEPDB1\lw10\FILES

-- 3. Создание пользователя lob_user с необходимыми привилегиями
CREATE USER lob_user IDENTIFIED BY lob_user
  DEFAULT TABLESPACE users
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO lob_user;
GRANT CREATE TABLE TO lob_user;
GRANT CREATE SEQUENCE TO lob_user;
GRANT CREATE ANY DIRECTORY TO lob_user;
    GRANT DROP ANY DIRECTORY TO lob_user;

ALTER USER lob_user QUOTA 100M ON lob_data;

-- 5.
CREATE TABLE lob_user.my_table (
  id NUMBER,
  foto BLOB,
  doc BFILE
);


CREATE DIRECTORY dir4 AS 'C:\test';

-- 6.

DECLARE
  src_bfile BFILE;
  dest_blob BLOB;
BEGIN
  INSERT INTO lob_user.my_table (id, foto, doc)
  VALUES (1, empty_blob(), BFILENAME('dir4', 'document.docx'))
  RETURNING foto, doc INTO dest_blob, src_bfile;

  DBMS_LOB.fileopen(src_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.loadfromfile(dest_blob, src_bfile, DBMS_LOB.getlength(src_bfile));
  DBMS_LOB.fileclose(src_bfile);
  COMMIT;
END;
/


