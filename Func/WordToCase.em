/*
���ģ��Ե�ǰѡ����ı�������չ,��ÿһ�е��ı���Ϊһ��case,�Զ���չΪ
case ###:
break;
����ʽ.����չ������ݻᱣ���ڼ��а���,������ֱ�Ӳ��뵱ǰλ��.
*/

macro EndWTC(hbufClip)
{
	AppendBufLine(hbufClip, "default:")
	AppendBufLine(hbufClip, "	break;")
	stop
}

macro WordToCase()
{
	hwnd = GetCurrentWnd ()
	if ( hnil == hwnd )
	{
		msg("wnd null");
		return
	}
	hbuf = GetWndBuf (hwnd)
	if ( hnil == hbuf )
	{
		msg("buf null");
		return
	}
	sel = GetWndSel (hwnd)

	if ( TRUE != sel.fExtended )
	{
	/*	hbufClip = GetBufHandle("Clipboard")
		if ( hnil == hbufClip )
		{
			return
		}
		else
		{
			
		}*/
		return
	}

	
	hbufClip = GetBufHandle("Clipboard")
	if ( hnil == hbufClip )
	{
		msg("clip board null");
		return
	}
	ClearBuf (hbufClip)

	ln = sel.lnFirst
	posx = sel.ichFirst

	while(1)
	{
		str = GetBufLine (hbuf, ln)
		while(1)
		{
			GWord = GetWordInAString(str,posx,1)
			if ( nil == GWord )
			{
				if ( ln == sel.lnLast )
				{
					//end
					EndWTC(hbufClip)
				}
				else
				{
					ln = ln + 1
					posx = 0
					break;
				}
			}
			else
			{
				if ( ln == sel.lnLast )
				{
					if ( GWord.position > sel.ichLim )
					{
						//end
						EndWTC(hbufClip)
					}
				}
				//got one word
				text = cat("case ",GWord.word)
				text = cat(text,":")
				AppendBufLine(hbufClip, text)
				text = "	break;"
				AppendBufLine(hbufClip, text)
				posx = GWord.position
			}
		}
	}
}

