#
# Name: v$meta_lock
# Author: YJ
# Date: 2016.06.27
# 선수조건: INSTALL SONAME 'metadata_lock_info';
# MariaDB에 있는 meta lock 현황보기
# 
CREATE OR REPLACE
ALGORITHM=UNDEFINED 
DEFINER = 'root'@'localhost'
SQL SECURITY INVOKER
VIEW sys.`v$meta_lock`
AS
SELECT meta.table_schema AS schema_name
      ,meta.table_name AS object_name
      ,REPLACE(meta.lock_type, ' metadata lock', '') AS meta_lock_type
      ,meta.lock_mode AS meta_lock_mode
      ,meta.lock_duration AS meta_lock_duration
      ,ps.id AS thread_id
      ,concat(ps.user, '@', substring_index(ps.host, ':', 1)) AS user
      ,ps.command AS thread_status
      ,ps.time AS thread_time_sec
      ,info AS thread_info
      ,concat('KILL ', ps.id) as kill_thread
  FROM information_schema.metadata_lock_info meta
  LEFT OUTER JOIN information_schema. processlist ps
    ON meta.thread_id = ps.id
;