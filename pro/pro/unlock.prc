create or replace procedure unlock is
begin
  --��ձ���ס���û�
  delete from ticketgrantingticket;
  delete from serviceticket;
  commit;
end unlock;
/

