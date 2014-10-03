var radioQuestion = new Array();
var checkBoxQuestion = new Array();
var dropDownQuestion = new Array();
var textQuestion = new Array();
var record = new Array();
var answerRecord=new Array();

$(function() {
			$("#questionNum").text("current questions num:0");
		});

function deleteDiv(val) {
	$("#div" + val).remove();
}

function typeChange(){
	var type=$("#type").val();
	if(type==4){
		doReset();
	}
}

function addAnswer() {
	var type=$("#type").val();
	if(type==4){
		alert("only allow one input text!");
	}else{
		var index = $("div[id^='div']").length;
		index++;
		$("#addSpan")
				.append("<div id='div"
						+ index
						+ "'>answer"
						+ index
						+ ":&nbsp;&nbsp;<input type='text' class='textcss' name='inputAnswer'/>&nbsp;<input type='button' class='submitbutton' value='delete' onclick='deleteDiv("
						+ index + ")'/></div>");
	}
}

function addQuestion() {
	var type = $("#type").val();
	var question = $("#inputQuestion").val();
	var answers = document.getElementsByName("inputAnswer");
	var ansArray = new Array();
	for (var i = 0; i < answers.length; i++) {
		ansArray.push($(answers[i]).val());
	}
	var obj = new Object();
	obj.question = question;
	obj.answers = ansArray;
	var curRecord = new Object();
	if (type == 1) {
		curRecord.index = radioQuestion.length;
		curRecord.type = 1;
		record.push(curRecord);
		radioQuestion.push(obj);
	} else if (type == 2) {
		curRecord.index = checkBoxQuestion.length;
		curRecord.type = 2;
		record.push(curRecord);
		checkBoxQuestion.push(obj);
	} else if (type == 3) {
		curRecord.index = dropDownQuestion.length;
		curRecord.type = 3;
		record.push(curRecord);
		dropDownQuestion.push(obj);
	} else if (type == 4) {
		curRecord.index = textQuestion.length;
		curRecord.type = 4;
		record.push(curRecord);
		textQuestion.push(obj);
	}
	$("#questionNum").text("current questions num:" + record.length);
	alert("success");
	doReset();
}

function doReset() {
	$("#inputQuestion").val("");
	$("#inputAnswer1").val("");
	$("#addSpan").text("");
}

function doAnswer() {
	if (record != null && record.length > 0) {
		showAllQuestions();
	} else {
		alert("Please add the questions first!");
	}
}

function showAllQuestions() {
	var index = 0;
	for (var i = 0; i < record.length; i++) {
		index++;
		var obj = record[i];
		if (obj.type == 1) {
			var radioObj = radioQuestion[obj.index];
			var question = "<span class='font_title'>"+index + ". " + radioObj.question + "</span><br>";
			var arr = radioObj.answers;
			for (var q = 0; q < arr.length; q++) {
				question += "<div class='radiocss'><input type='radio' name='radio" + obj.index + "'"
						+ " value='" + arr[q] + "'/>" + arr[q] + "</div>";
			}
			$("#survey").append(question + "<br>");
		} else if (obj.type == 2) {
			var checkBoxObj = checkBoxQuestion[obj.index];
			var question = "<span class='font_title'>"+index + ". " + checkBoxObj.question +  "</span><br>";
			var arr = checkBoxObj.answers;
			for (var q = 0; q < arr.length; q++) {
				question += "<div class='checkboxcss'><input type='checkbox' name='checkbox" + obj.index
						+ "'" + " value='" + arr[q] + "'/>" + arr[q] + "</div>";
			}
			$("#survey").append(question + "<br>");
		} else if (obj.type == 3) {
			var dropDownObj = dropDownQuestion[obj.index];
			var question = "<span class='font_title'>"+index + ". " + dropDownObj.question +  "</span><br>";
			var arr = dropDownObj.answers;
			question += "<select class='selectcss' id='select" + obj.index + "'>";
			for (var q = 0; q < arr.length; q++) {
				question += "<option value='" + arr[q] + "'>" + arr[q]
						+ "</option>";
			}
			question += "</select><br>";
			$("#survey").append(question + "<br>");
		} else if (obj.type == 4) {
			var textObj = textQuestion[obj.index];
			var question = "<span class='font_title'>"+index + ". " + textObj.question +  "</span><br>";
			var arr = textObj.answers;
			for (var q = 0; q < arr.length; q++) {
				question += "<input type='text' class='textcss' name='text" + obj.index + "'"
						+ " value=''/><br>";
			}
			$("#survey").append(question + "<br>");
		}
	}
	$("#survey")
			.append("<br><input type='button' class='submitbutton' value='submit' onclick='submitAnswers()'/>");
	$("#questionDiv").hide();
	$("#survey").show();
}

function submitAnswers() {
	var show="true";
	for (var i = 0; i < record.length; i++) {
		var obj = record[i];
		var recordObj=new Object();
		if (obj.type == 1) {
			var rec=$('input[name="radio'+obj.index+'"]:checked').val();
			if(rec!=null && rec.length>0){
				recordObj.type=obj.type;
				recordObj.index=obj.index;
				var radioObj = radioQuestion[obj.index];
				recordObj.question=radioObj.question;
				recordObj.answer=rec;
				answerRecord.push(recordObj);
			}else{
				show="false";
				showAnswers(show);
				break;
			}
		} else if (obj.type == 2) {
			var rec=new Array();
			$("input[name='checkbox"+obj.index+"']:checked").each(function () {
			 	rec.push(this.value);
            });
            if(rec.length>0){
            	recordObj.type=obj.type;
				recordObj.index=obj.index;
				var checkBoxObj = checkBoxQuestion[obj.index];
				recordObj.question=checkBoxObj.question;
				recordObj.answer=rec;
				answerRecord.push(recordObj);
            }else{
            	show="false";
				showAnswers(show);
				break;
            }
		} else if (obj.type == 3) {
			var rec=$("#select"+obj.index).val();
			if(rec!=null && rec.length>0){
				recordObj.type=obj.type;
				recordObj.index=obj.index;
				var dropDownObj = dropDownQuestion[obj.index];
				recordObj.question=dropDownObj.question;
				recordObj.answer=rec;
				answerRecord.push(recordObj);
			}else{
				show="false";
				showAnswers(show);
				break;
			}
		} else if (obj.type == 4) {
			var rec=new Array();
			$("input[name='text"+obj.index+"']").each(function () {
			 	rec.push(this.value);
            });
			if(rec.length>0){
            	recordObj.type=obj.type;
				recordObj.index=obj.index;
				var textObj = textQuestion[obj.index];
				recordObj.question=textObj.question;
				recordObj.answer=rec;
				answerRecord.push(recordObj);
            }else{
            	show="false";
				showAnswers(show);
				break;
            }
		}		
	}
	if(show=="true"){
		showAnswers(show);
	}
}

function showAnswers(show){
	if(show=="true"){
		$("#survey").html("");
		var index=0;
		for(var i=0;i<answerRecord.length;i++){
			index++;
			var obj = answerRecord[i];
			if (obj.type == 1 || obj.type == 3) {
				var question="<span class='font_title'>"+index+". "+obj.question+"</span><br><span>your answer:&nbsp;"+obj.answer+"</span><br>";
				$("#survey").append(question+"<br>");
			}else if (obj.type == 2 || obj.type == 4) {
				var question="<span class='font_title'>"+index+". "+obj.question+"</span><br>";
				var rec=obj.answer;
				var recVal="";
				for(var q=0;q<rec.length;q++){
					recVal+=rec[q]+";";
				}
				question+="<span>your answer:&nbsp;"+recVal+"</span><br>";
				$("#survey").append(question+"<br>");
			}
		}
	}else{
		alert("All the questions must be answered!");
	}
}