 /**
 * �������ѡ�б���е�һ��
 */
function  selectThis(obj,tableId){

var actionTable = getObject(tableId);
  for(var i=1;i<actionTable.rows.length;i++){
    actionTable.rows[i].className="";
  }
   obj.className= "bg2";
}

