/*  
    Copyright (C) 2012 by alexandre coffignal <alexandre.github@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <errno.h>
#include <sys/time.h>
#include <time.h>
#define MAX_BUF	1024
#define MAX_DEV	30
#define MIN_DETECT	7
#define RS_TIMEOUT	10000	//1ms
#define MAX_VERBOSE_LEVEL 2
#define CVS_FILE_NAME	"data.csv"
#define NB_TRY 3
#define NB_JOUR 256
#define NB_HEURE 24

#define HEADER_DAY 4
float afKWatt[NB_JOUR][NB_HEURE];


static int _iVerbose=0;
static char _acDevice[MAX_DEV];
static int _iFunction=-1;
static time_t _tTime;
int (*pvPrint1) (char * acFormat, ...);
int (*pvPrint2) (char * acFormat, ...);


static void rs_vSigcatch( int sig )
{
	//printf("   Comm USB: timeout\n" );
}

int iQuiet (char * acFormat, ...)
{
	return 0;
}


static void vSetVerbose(int iLevel)
{
	_iVerbose=1;
	if(iLevel>0)
		pvPrint1=(void*)printf;
	if(iLevel>1)
		pvPrint2=(void*)printf;

}


/* Fixe un device en mode RAW */
void raw_mode (int fd, struct termios *old_term)
{

	struct termios term;

	tcgetattr(fd, &term);

	/* Sauve l'ancienne config dans le paramètre */
	tcgetattr(fd, old_term);

	/* mode RAW, pas de mode canonique, pas d'echo */
	term.c_iflag = IGNBRK;

	term.c_lflag = 0;
	term.c_oflag = 0;

	/* 1 caractère suffit */
	term.c_cc[VMIN] = 1;

	/* Donnée disponible immédiatement */
	term.c_cc[VTIME] = 5;

	/* Inhibe le controle de flux XON/XOFF */
	term.c_iflag &= ~(IXON|IXOFF|IXANY);

	/* 38400 bauds */
	term.c_cflag = B38400;
	/* 8 bits de données, pas de parité */
	term.c_cflag &= ~(PARENB | CSIZE);
	term.c_cflag |= CS8;

	/* Gestion des signaux modem */
	term.c_cflag &= ~CLOCAL;

	tcsetattr(fd, TCSANOW, &term);
}



static void _vUsage(char * acName)
{
	printf("usage : %s [-v] [-l!] [-h]\n",acName);
	printf("-h, --help : aide\n");
	printf("-v, --verbose : verbose\n");
	printf("-l!, --log_off : pas de log\n");
}

unsigned int alarm_us (long int liUsec)
{
	struct itimerval old, new;
	new.it_interval.tv_usec = 0;
	new.it_interval.tv_sec = 0;
	new.it_value.tv_usec = liUsec;
	new.it_value.tv_sec = 0;
	if (setitimer (ITIMER_REAL, &new, &old) < 0)
		return 0;
	else
		return old.it_value.tv_sec;
}

int iGetData(int fd,const unsigned char * aucTx,int iTxLen, unsigned char pucRx[MAX_BUF])
{
	struct sigaction action;
	int i=0,ret;
	int iTimeout=RS_TIMEOUT;
	int iOut=0;
	unsigned int uiRead=0;
	unsigned char buf[MAX_BUF];

	action.sa_handler = rs_vSigcatch;
	sigaction(SIGALRM, &action, NULL);

	pvPrint2("=> ");
	ret=write(fd,aucTx,iTxLen);
	if(ret<0)
	{
		perror("write");
		uiRead=ret;
	}
	else
	{
		for(i=0;i<ret;i++)
		{
			pvPrint2("0x%02X ",aucTx[i]);
		}
		pvPrint2("\n");

		do
		{

			alarm_us (RS_TIMEOUT);
			ret=read(fd,(void*)buf,MAX_BUF);
			if(ret>0)
			{
				alarm(0);
				pvPrint2("<= ");
				for(i=0;i<ret;i++)
				{
					pvPrint2("0x%02X ",(unsigned char)buf[i]);
					pucRx[i+uiRead]=buf[i];
				}
				pvPrint2("\n");
				uiRead+=ret;
			}
			else
			{
				iOut=1;
				if(errno!=EINTR)
				{
					uiRead=ret; //pas un timeout : vrai erreur
					alarm(0);
					perror("read");
				}

			}
		}while(iOut==0);

	}

	return uiRead;
}

//fonction 1
int iTestCx(int fd)
{
	//trame ping
	const unsigned char aucTestCx[]={0x45,0x4C,0x01,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1;

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	if(iGetData(fd,aucTestCx,sizeof(aucTestCx),aucRecu)==4)
	{
		if(aucRecu[3]==0xA5)
		{
			ret=0;
		}
	}
	return ret;
}
//fonction 2
int iFonction2(int fd,int iNb)
{

	unsigned char aucFunction[]={0x45,0x4C,0x02,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,irecu;
	pvPrint1("Fonction 2 arg %d\n",iNb);
	aucFunction[3]=iNb;

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	if(irecu = iGetData(fd,aucFunction,sizeof(aucFunction),aucRecu)==10)
	{
		printf("arg = %d ",iNb);
		for(i=0;i<6;i++)
		{
			printf("0x%02x ",aucRecu[i + HEADER_DAY]);
		}
		printf("\n");
		ret=0;
	}

	pvPrint1("%d\n",irecu);
	return ret;
}

float fGetKWatt(unsigned char ucMSB,unsigned char ucLsb,unsigned char ucExp)
{
	unsigned long ulExp;
	float fKWatt;
	switch(ucExp)
	{
	case 249: ulExp = 4194304;break;
	case 250: ulExp = 2097152;break;
	case 251: ulExp = 1048576;break;
	case 252: ulExp = 524288;break;
	case 253: ulExp = 262144;break;
	case 254: ulExp = 131072;break;
	case 255: ulExp = 65536;break;
	case 0: ulExp = 32768;break;
	case 1: ulExp = 16384;break;
	case 2: ulExp = 8192;break;
	case 3: ulExp = 4096;break;
	case 4: ulExp = 2048;break;
	case 5: ulExp = 1024;break;
	case 6: ulExp = 512;break;
	case 7: ulExp = 256;break;
	case 8: ulExp = 128;break;
	case 9: ulExp = 64;break;
	case 10: ulExp = 32;break;
	case 11: ulExp = 16;break;
	case 12: ulExp = 8;break;
	case 13: ulExp = 4;break;
	case 14: ulExp = 2;break;
	case 15: ulExp = 1;break;
	default :
		printf("Exposant non correct\n");
		ulExp = 1;
		break;
	}
	fKWatt = (float)((int)ucMSB * 256 + ucLsb) / ulExp;
	return fKWatt;
}

//fonction 3
int iGetDay(int fd,int iDay)
{
	unsigned char aucGetDay[]={0x45,0x4C,0x03,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,iNb=0;


	aucGetDay[3]=iDay;
	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);



	if((iNb=iGetData(fd,aucGetDay,sizeof(aucGetDay),aucRecu))==76)
	{

		for(i=0;i<NB_HEURE;i++)
		{
			unsigned char ucMSB = aucRecu[i*3 + HEADER_DAY];
			unsigned char ucLsb = aucRecu[i*3 + HEADER_DAY +1 ];
			unsigned char ucExp = aucRecu[i*3 + HEADER_DAY +2 ];


			float fkWatt = fGetKWatt(ucMSB,ucLsb,ucExp);
			pvPrint1("%x %x %x %f\n",ucMSB,ucLsb,ucExp,fkWatt);

			afKWatt[iDay][i]=fkWatt;
		}
		ret=0;
	}
	else
	{
		pvPrint1("Probleme : Recu %d\n",iNb);
	}


	return ret;
}

//fonction 4 quit le mode communication de l'ecowatt
int iFonction4(int fd,int iNb)
{

	unsigned char aucFunction[]={0x45,0x4C,0x04,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,irecu;
	pvPrint1("Fonction 4 arg %d\n",iNb);
	aucFunction[3]=iNb;

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	irecu = iGetData(fd,aucFunction,sizeof(aucFunction),aucRecu);
	printf("recu %d ",irecu);
	{
		printf("arg = %d ",iNb);
		for(i=0;i<irecu;i++)
		{
			printf("0x%02x ",aucRecu[i + HEADER_DAY]);
		}
		printf("\n");
		ret=0;
	}

	pvPrint1("%d\n",irecu);
	return ret;
}
//fonction 5 ???
int iFonction5(int fd,int iNb)
{

	unsigned char aucFunction[]={0x45,0x4C,0x05,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,irecu;
	pvPrint1("Fonction 4 arg %d\n",iNb);
	aucFunction[3]=iNb;

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	irecu = iGetData(fd,aucFunction,sizeof(aucFunction),aucRecu);
	if(irecu==7)
	{
		unsigned char ucMSB = aucRecu[HEADER_DAY];
		unsigned char ucLsb = aucRecu[HEADER_DAY +1 ];
		unsigned char ucExp = aucRecu[HEADER_DAY +2 ];

		float fKWatt = fGetKWatt(ucMSB,ucLsb,ucExp);
		pvPrint1("%x %x %x %f\n",ucMSB,ucLsb,ucExp,fKWatt);

		for(i=0;i<irecu;i++)
		{
			printf("0x%02x ",aucRecu[i + HEADER_DAY]);
		}
		printf("\n");
		ret=0;
	}

	pvPrint1("%d\n",irecu);
	return ret;
}

//fonction 6 moy watt jour de la sem
int iFonction6(int fd,int iNb)
{

	unsigned char aucFunction[]={0x45,0x4C,0x06,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,irecu;
	pvPrint1("Fonction 6 arg %d\n",iNb);
	aucFunction[3]=iNb;

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	irecu = iGetData(fd,aucFunction,sizeof(aucFunction),aucRecu);
	if(irecu==7)
	{
		unsigned char ucMSB = aucRecu[HEADER_DAY];
		unsigned char ucLsb = aucRecu[HEADER_DAY +1 ];
		unsigned char ucExp = aucRecu[HEADER_DAY +2 ];

		float fKWatt = fGetKWatt(ucMSB,ucLsb,ucExp);
		pvPrint1("%x %x %x %f\n",ucMSB,ucLsb,ucExp,fKWatt);

		for(i=0;i<irecu;i++)
		{
			printf("0x%02x ",aucRecu[i + HEADER_DAY]);
		}
		printf("\n");
		ret=0;
	}

	pvPrint1("%d\n",irecu);
	return ret;
}


//fonction 8 heure
int iGetDate(int fd)
{

	unsigned char aucFunction[]={0x45,0x4C,0x08,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,irecu;
	pvPrint1("Get EcoWatt Time\n");

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	irecu = iGetData(fd,aucFunction,sizeof(aucFunction),aucRecu);
	if(irecu==9)
	{
		struct tm t;

		t.tm_year = aucRecu[HEADER_DAY]		+ 100;
		t.tm_mon  = aucRecu[HEADER_DAY+1] 	- 1;
		t.tm_mday = aucRecu[HEADER_DAY+2];
		t.tm_hour = aucRecu[HEADER_DAY+3];
		t.tm_min  = aucRecu[HEADER_DAY+4];
		t.tm_sec  = 0;

		_tTime = mktime(&t);

		pvPrint1("Date et heure: %s\n", ctime(&_tTime));
		ret=0;
	}
	return ret;
}


//fonction generique
int iFonction(int fd,int iFonction,int iarg)
{

	unsigned char aucFunction[]={0x45,0x4C,0x00,0x00};
	unsigned char  aucRecu[MAX_BUF];
	int i=0,ret=-1,irecu;
	pvPrint1("Fonction %d arg %d\n",iFonction,iarg);
	aucFunction[2]=iFonction;
	aucFunction[3]=iarg;

	bzero(aucRecu, sizeof(unsigned char)*MAX_BUF);
	irecu = iGetData(fd,aucFunction,sizeof(aucFunction),aucRecu);
	printf("recu %d ",irecu);
	{
		printf("arg = %d ",iarg);
		for(i=0;i<irecu;i++)
		{
			printf("0x%02x ",aucRecu[i]);
		}
		printf("\n");
		ret=0;
	}

	pvPrint1("%d\n",irecu);
	return ret;
}

void vStop(int fd)
{
	if(fd)
	{
		pvPrint1("close comm\n");
		close(fd);
	}
}
static int iRun()
{
	int fd=0,i=0,j,ret=0,try;
	int iDay,iHour;
	//unsigned char buf[MAX_BUF];
	struct termios term;

	fd=open(_acDevice,O_RDWR);
	if(fd<=0)
	{
		perror("open");
		return 0;
	}

	pvPrint1("Test du port comm\n");
	if(iTestCx(fd))
	{
		printf("Ecowatt not found\n");
		vStop(fd);
		ret=-1;
	}
	else
	{
		if(_iFunction==-1)
		{

			pvPrint1("Ecowatt ready\n");
			if(iGetDate(fd))
			{
				printf("Ecowatt Date not found\n");
				ret=-1;
			}
			for(i=0;i<NB_JOUR;i++)
			{
				printf("%d pct\n\r",(i*100)/255);
				for(try=0;try<NB_TRY;try++)
				{
					if(iGetDay(fd,i))
					{
						printf("Recuperation jour %d  => ko\n",i);
					}
					else
					{
						pvPrint1("Recuperation jour %d  => ok\n",i);
						break;
					}
				}

			}

			FILE * fp;
			if ((fp = fopen(CVS_FILE_NAME,"w+")) == NULL)
			{
				fprintf(stderr,"Impossible d'ouvrir le fichier données en lecture\n");
			}
			else
			{
				fprintf(fp,";",iHour);
				for(iDay=0;iDay<NB_JOUR;iDay++)
				{
					struct tm *tb;
					_tTime-=24*60*60;
					tb = localtime(&_tTime);
					fprintf(fp,"%02d/%02d/%02d;", tb->tm_mday,tb->tm_mon+1,tb->tm_year-100);
				}
				fprintf(fp,"\n");
				for(iHour=0;iHour<NB_HEURE;iHour++)
				{
					fprintf(fp,"%02d:00;",iHour);
					for(iDay=0;iDay<NB_JOUR;iDay++)
					{
						fprintf(fp,"%f;", afKWatt[iDay][iHour]);
					}
					fprintf(fp,"\n");
				}
				fclose(fp);
			}
		}
		else
		{
			for(i=0;i<255;i++)
			{
				iFonction(fd,_iFunction,i);
			}
		}

		vStop(fd);
	}
	return ret;
}


int iGetArg(int argc, char *argv[])
{
	int i;
	int level;
	for(i=0;i<argc;i++)
	{
		//mode verbeux ou pas
		if((!strcmp(argv[i],"-v"))||(!strcmp(argv[i],"--verbose")))
		{

			if(argc>=i+1)
			{
				level = atoi(argv[i+1]);
				if((level<=MAX_VERBOSE_LEVEL) && (level>0))
				{
					i++;
				}
				else
				{
					level=1;
				}
			}
			else
			{
				level=1;
			}
			printf("Verbose mode level %d\n",level);
			vSetVerbose(level);
		}

		if((!strcmp(argv[i],"-h"))||(!strcmp(argv[i],"--help")))
		{
			_vUsage(argv[0]);
			return -1;
		}

		if((!strcmp(argv[i],"-d"))||(!strcmp(argv[i],"--device")))
		{
			if(argc>=i+1)
			{
				i++;
				pvPrint1("Device %s\n",argv[i]);
				strncpy(_acDevice,argv[i],MAX_DEV);
			}
		}
		if((!strcmp(argv[i],"-f"))||(!strcmp(argv[i],"--function")))
		{

			if(argc>=i+1)
			{
				_iFunction = atoi(argv[i+1]);
				i++;
			}
			else
			{
				_iFunction=-1;
			}
			printf("mode function %d\n",_iFunction);
		}
	}
	return 0;
}

int main (int argc, char *argv[])
{
	//init
	pvPrint1=iQuiet;
	pvPrint2=iQuiet;
	strncpy(_acDevice,"/dev/ttyUSB0",MAX_DEV);
	//get arguments
	iGetArg(argc,argv );

	//process
	return iRun();
}
