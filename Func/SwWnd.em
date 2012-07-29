/*
���ģ������ͷ�ļ���Դ�ļ����л�
��ģ�����������SwWnd,����������Ϊ�����Ӻ���
�����������������ִ�Сд������Ϊ��д��ĸ��
Сд��ĸ���÷ֱ����»��ߵ����ߣ�����ö��ַ�
���ҵ�ʱ�������б������»��ߵ��ļ������׵���
����ʧ�ܣ���˻������ִ�Сд��
*/

// ����ָ�����ļ�.
// �������ҵ���Ӧ���ļ���,������ļ�
// opfl : Ҫ��������ļ�
macro ActSpecFile(opfl)
{
	var cobuf;
	var hwnd;
	cobuf = GetFileHandle(opfl)
			
	if ( hnil != cobuf)
	{
		SetCurrentBuf (cobuf)
		
		hwnd = GetWndHandle(cobuf)
		if ( hnil == hwnd )
		{
			newwnd(cobuf)
			hwnd = GetWndHandle(cobuf)
			if ( hnil == hwnd )
			{
				msg("should not come hrer...")
				return 0
			}
		}
		SetCurrentWnd(hwnd)
		return 1
	}
	else
	{
		// check if the file not in project, but it is opened in cache.
		var cwnd
		cwnd = WndListCount ()
		var iwnd
		iwnd = 0
		while (iwnd < cwnd)
		{
			hwnd = WndListItem(iwnd)
			var hbuf
			hbuf = GetWndBuf (hwnd)
			var filename
			filename = GetBufName (hbuf)
			filename = GetFileNameFromFullPath(filename)
			if ( opfl == filename)
			{
				SetCurrentWnd(hwnd)
				return 1;
			}
			iwnd = iwnd + 1
		}
	}
	return 0
}

//switch to coressponding window
macro SwWnd()
{
	var hwnd;
	var hbuf;
	var filename;
	var len
	var ichLim
	var opfl
	var tmp
	var ichFirst
	var cobuf
	
	hbuf = GetCurrentBuf ()
	filename = GetBufName (hbuf)
	filename = GetFileNameFromFullPath(filename)
	len = strlen (filename)
	filename = tolower (filename)
	
	ichLim = len;
	if ( len > 4 )
	{
		ichFirst = len - 4;
		tmp = strmid (filename, ichFirst, ichLim);
		if ( ".cpp" == tmp )
		{
			// check the corresponding h file
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"h");

			if ( ActSpecFile(opfl) )
			{
				return;
			}

			// if h file not found, check hpp file
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"hpp");
			if ( !ActSpecFile(opfl) )
			{
				msg("Could not found header file in project!")
			}
		}
	}
	if ( len > 2 )
	{

		ichFirst = len - 2;
		tmp = strmid (filename, ichFirst, ichLim);
		if ( ".h" == tmp )
		{
			// check the corresponding c file
			opfl = strmid (filename, 0, ichFirst +1)
			opfl = cat(opfl,"c");
			if ( ActSpecFile(opfl) )
			{
				return
			}

			// if c file not found, check corresponding cpp file
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"cpp");
			if ( !ActSpecFile(opfl) )
			{
				msg("Could not found source file in project!")
			}
			return ;
		}
		
		if ( ".c" == tmp )
		{
			opfl = strmid (filename, 0, ichFirst+1)
			opfl = cat(opfl,"h");
			if ( !ActSpecFile(opfl) )
			{
				msg("Could not found header file in project!")
			}
			return;
		}
	}
}


