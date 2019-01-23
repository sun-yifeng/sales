create or replace procedure unlock is
begin
  --清空被锁住的用户
  delete from ticketgrantingticket;
  delete from serviceticket;
  commit;
end unlock;
/

