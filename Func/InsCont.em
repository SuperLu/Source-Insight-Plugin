/*
���ģ��������ִ�в����ı��ģ��������ٲ���extern,include�ȹؼ��֣���
�ѹ���ƶ������ʵ�λ�õȴ�����
*/

// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}
// �Ѳ����ַ������뵽��ǰ����ѡ�����ݵ�����
// prefix : ���뵽��ǰѡ�����ݵ�ǰ��
// subfix : ���뵽��ǰѡ�����ݵĺ���
// �����ǰ�����Ѿ�ѡ���˲����ı�,������ݲ��뵽��Щ�ı����ڵ�ÿһ�е�ǰ���Լ�����
// �����ǰ����û��ѡ���ı�,��ֻ�����ݲ��뵽��ǰλ��
macro InsHeadNTail2Lines(prefix,suffix)
{
	var hwnd;
	var hbuf;
	var sel;
	var ln;
	var sz;
	var str;
	var len;

	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	// �����ǰ�Ѿ�ѡ�����ݣ���Ҫ��prefix & subfix���뵽
	// ��Щ���ݵ�ÿһ��
	if(sel.fExtended)
	{
		if ( sel.lnfirst != sel.lnlast)
		{
			ln = sel.lnFirst
			// ��prefix & subfix ����ÿһ��
			while(ln <= sel.lnLast)
			{
				str = GetBufLine (hbuf, ln)
				str = cat(prefix,str)
				str = cat(str,suffix)
				DelBufLine (hbuf, ln)
				InsBufLine (hbuf, ln, str)
				ln = ln + 1
			}
			// ѡ�����в���������
			sel.ichFirst = 0;
			sz = getbufline(hbuf,sel.lnlast)
			sel.ichLim = strlen(sz)
			SetWndSel(hwnd,sel)
		}
		else
		{
			SetBufIns (hbuf, sel.lnfirst, sel.ichlim)
			SetBufSelText(hbuf,suffix)
			SetBufIns (hbuf, sel.lnfirst, sel.ichfirst)
			SetBufSelText(hbuf,prefix)
		}
	}
	else
	{
		// ���û��ѡ���ı�,��ֻ���뵽��ǰλ��
		str = cat(prefix,suffix)
		SetBufSelText(hbuf, str)
		len = strlen(suffix)
		while(len>0)
		{
			cursor_left
			len = len - 1
		}
	}
}

//insert string "#define "
macro Define()
{
	InsHeadNTail2Lines("#define ","")
}
//insert string "extern "
macro Extern()
{
	InsHeadNTail2Lines("extern ","")
}

macro InsGccAsm()
{
	InsHeadNTail2Lines("__asm__ (\"","\");")
}

//insert my name and the current data.
macro InsNameAndTime()
{
	hbuf = GetCurrentBuf()
	tmp = GetDate()
	tmp = Cat("Eden Zhong ",tmp)
	tmp = Cat(tmp,"    ")
	SetBufSelText(hbuf, tmp)
}


// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	SetBufSelText (hbuf, "Returns True if successful or False if errors.")
}

//insert string "void "
macro void()
{
	InsHeadNTail2Lines("void","")
}
//insert string "NULL == "
macro Null()
{
	InsHeadNTail2Lines("NULL","")
}
//insert string "#include "
macro Include()
{
	if ( "python" == GetCurFileType() )
	{
		InsHeadNTail2Lines("import ","")
	}
	else
	{
		InsHeadNTail2Lines("#include \"",".h\"")
	}
}
macro IncludeSys()
{
	if ( "python" == GetCurFileType() )
	{
		InsHeadNTail2Lines("import ","")
	}
	else
	{
		InsHeadNTail2Lines("#include <",">")
	}
}
macro InsTemplate()
{
	InsHeadNTail2Lines("template <typename T",">")
}
macro InsSpaceAfterCursor()
{
	hbuf = GetCurrentBuf()
	SetBufSelText(hbuf, " ")
	Cursor_Left
}
macro InsReturn()
{
	InsHeadNTail2Lines("return ",";")
}

macro InsCurlyReturn()
{
	InsHeadNTail2Lines("{return ",";}")
}

// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
	sz = Ask("Enter ifdef condition:")
	if (sz != "")
		IfdefSz(sz);
}

macro InsertCPlusPlus()
{
	IfdefSz("__cplusplus");
}

macro InsToDo()
{
	InsHeadNTail2Lines("todo(\"","\")")
}
macro InsDefence()
{
	hbuf = GetCurrentBuf()
	SetBufSelText(hbuf, "// defence // ")
}

//insert multiline comment
macro InsMulCmt()
{
	var hwnd
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	var hbuf
	hbuf = GetWndBuf (hwnd)
	var sel
	sel = GetWndSel (hwnd)

	var str

	// get base indent
	var base_indent
	str = GetBufLine (hbuf, sel.lnfirst)
	base_indent = get_pre_space(str)

	var ln
	ln = sel.lnfirst+1
	var tmp
	var pos
	while(ln <= sel.lnlast )
	{
		str = GetBufLine (hbuf, ln)
		tmp = get_pre_space(str)
		pos = strcmp(base_indent,tmp)
		if ( pos > 0 )
		{
			base_indent = strmid(base_indent,0,pos-1)
		}
		else if ( pos < 0 )
		{
			base_indent = strmid(base_indent,0,0-1-pos)
		}
		ln = ln + 1
	}

	// plus
	var plus
	plus = IndentSign()
	plus = cat("*",plus)

	pos = strlen(base_indent)

	var new_line_content

	
	ln = sel.lnlast
	while(ln>= sel.lnfirst)
	{
		str = GetBufLine (hbuf, ln)
		tmp = strmid(str,0,pos)
		new_line_content = cat(tmp,plus)
		tmp = strmid(str,pos,strlen(str))
		new_line_content = cat(new_line_content,tmp)
		PutBufLine (hbuf, ln, new_line_content)

		ln = ln - 1
	}
	InsBufLine (hbuf, sel.lnlast+1, base_indent # "***********************************************************/")
	InsBufLine (hbuf, sel.lnfirst, base_indent # "/***********************************************************")
	Cursor_down
	end_of_line
}
