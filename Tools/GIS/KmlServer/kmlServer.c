#include<sys/types.h>
#include<sys/socket.h>
#include<stdio.h>
#include<netinet/in.h>
#include<string.h>
#include<unistd.h>
#include<stdlib.h>
#include<sys/wait.h>
#include<pthread.h>

#define KML_SOCKET 7474 
#define STATUS_SOCKET 4747

#define WHITE "\e[2;37m"
#define GREEN "\e[2;32m"
#define RED "\e[1;31m"
#define NEUTRAL "\e[m"

#define BL_Q_SIZE 47

#define KML_HEAD    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"\
                    "<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n"
#define KML_TAIL    "</kml>\r\n"

int acquireSocket(int *soc);
int bindToSocket(int soc, int port);
int shutdownSocket(int soc);
int listenToSocket(int soc);
int acceptOnSocket(int soc);
int sendReply(int soc);
int closeSocket(int soc);
int createKml(char** kml);
int placeMark(float lat, float lon, char** pm);
int kmlify(char *str, int *pts);

int serveKml();
int acceptStatusUpdate();
int sendStatusReply(int soc);
int acceptStatusUp(int soc);

int kmlsoc=1;
char _kml[180000];
int  _pts[512];

/*****************************************************
  *
  * main 
  *
  ***************************************************/
int main()
{
    int result=0;
  
    int r = 0;
    for(int i=0; i<521; i++) {
        r = random() % 100;
        if(r > 60) r = 60;
        _pts[i] = 0;
    }

   pthread_t kml_thread, status_thread; 
   pid_t ppid = getpid();

   pthread_create(&kml_thread, NULL, (void*) &serveKml, NULL);
   pthread_create(&status_thread, NULL, (void*) &acceptStatusUpdate, NULL);
   pthread_join(kml_thread, NULL);
   pthread_join(status_thread, NULL);

   return result;

}

/*****************************************************
  *
  * serveKml 
  *
  ***************************************************/
int serveKml() {
   
    int result = 0, soc = 0;

    if( (result = acquireSocket(&soc)) )            goto kml_end;
    if( (result = bindToSocket(soc,KML_SOCKET)) )   goto kml_end_clean;
    if( (result = listenToSocket(soc)) )            goto kml_end_clean;
  
  kmlsoc=0;  
    while(!result) {
        result = acceptOnSocket(soc);
    }

kml_end_clean:
    shutdownSocket(soc);

kml_end:
    return result;
}

int acceptStatusUpdate() {
    int result=0, soc = 0;

    //sleep(5);

    if( (result = acquireSocket(&soc)) )            goto status_end;
    if( (result = bindToSocket(soc,STATUS_SOCKET)) )   goto status_end_clean;
    if( (result = listenToSocket(soc)) )            goto status_end_clean;
    
    while(!result) {
        result = acceptStatusUp(soc);
    }

status_end_clean:
    shutdownSocket(soc);

status_end:
    return result;
}

/*****************************************************
  *
  * acquireSocket
  *
  ***************************************************/
int acquireSocket(int *soc)
{
    int result=0;
#ifdef DEBUG
   printf(WHITE "acquire socket\r\n" NEUTRAL);
#endif

    *soc = socket(PF_INET, SOCK_STREAM, 0);
    
    if(*soc < 0) {
        perror(RED "could not acquire socket" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else 
        printf(GREEN "OK (%d)\r\n" NEUTRAL, *soc);
#endif

    return result;
}

/*****************************************************
  *
  * bindToSocket 
  *
  ***************************************************/
int bindToSocket(int soc, int port)
{
    int result=0;
    struct sockaddr_in srvAddr;

#ifdef DEBUG
    printf(WHITE "bind socket %d to port %d\r\n" NEUTRAL, soc, port);
#endif

    //bind to socket
    srvAddr.sin_family = AF_INET;
    srvAddr.sin_port = htons(port);
    srvAddr.sin_addr.s_addr = INADDR_ANY;
    if( bind(soc,(const struct sockaddr*)&srvAddr, sizeof(srvAddr)) ) {
        perror(RED "could not bind to socket" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
    return result;
}


/*****************************************************
  *
  * shutdownSocket 
  *
  ***************************************************/
int shutdownSocket(int soc)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "shutdown socket %d\r\n" NEUTRAL, soc);
#endif

    if(shutdown(soc, SHUT_RDWR) == -1) {
        perror(RED "could not shutdown socket" NEUTRAL);
        result = -1;
    }
    else {
#ifdef DEBUG
        if(closeSocket(soc)) 
            printf(GREEN "OK\r\n" NEUTRAL);
#endif
    }

    return result;

}


/*****************************************************
  *
  * closeSocket 
  *
  ***************************************************/
int closeSocket(int soc)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "closing socket descriptor %d\n\r" NEUTRAL, soc);
#endif
    if(close(soc)) {
        perror(RED "could not close socket descriptor" NEUTRAL);
        result=-1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif

    return result;
}

/*****************************************************
  *
  * listenToSocket 
  *
  ***************************************************/
int listenToSocket(int soc)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "listen to socket %d\r\n" NEUTRAL, soc);
#endif

    if( listen(soc, BL_Q_SIZE) ) {
        perror(RED "could not lesten to socket" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif

    return result;
}

/*****************************************************
  *
  * acceptOnSocket 
  *
  ***************************************************/
int acceptOnSocket(int soc)
{
    int result=0;
    int cliSock=0;
#ifdef DEBUG
    printf(WHITE "accepting on socket %d\r\n" NEUTRAL, soc);
#endif

    //dont care about who is sending request
    if( (cliSock = accept(soc, NULL, NULL)) == -1 ) {
        perror(RED "failed to accept connection" NEUTRAL);
        result = -1;
    }
    else
    {
#ifdef DEBUG
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
        sendReply(cliSock);
    }


    return result;

}


/*****************************************************
  *
  * acceptStatusUp 
  *
  ***************************************************/
int acceptStatusUp(int soc)
{
    int result=0, cliSock=0;

#ifdef DEBUG
    printf(WHITE "accepting status updates on socket %d\r\n" NEUTRAL, soc);
#endif

    if ((cliSock = accept(soc, NULL, NULL)) == 0) {
        perror(RED "failed to accept status update" NEUTRAL);
        result = -1;
    }

    else
    {
        char rb[10];
        bzero(rb, 10);

        read(cliSock, rb, 1);
        read(cliSock, rb+1, 1);
        read(cliSock, rb+2, 1); 
        
    int pt = atoi(rb);
    _pts[pt] = 67;    
         
#ifdef DEBUG
        puts(rb);
        fflush(stdout);
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
        sendStatusReply(cliSock);
    }
    
    return result;
}

/*****************************************************
  *
  * sendReply 
  *
  ***************************************************/
int sendReply(int soc)
{
    int result=0;
    
    char* payload=NULL;
    createKml(&payload);

    int ps = strlen(payload) ;
    
    const char* head =   "HTTP/1.1 200 OK\r\n"
                        "Content-Type: text/plain\r\n"
                        "Content-Length: ";

    char payload_size[16]; 
    sprintf(payload_size, "%d", ps);
    const char* head_end = "\r\n\r\n";
    
    
    char* msg = malloc(
                             strlen(head) + 
                             strlen(payload_size) +
                             strlen(head_end) + 
                             strlen(payload) + 
                             0
                            );
    strcpy(msg, head);
    strncat(msg, payload_size, strlen(payload_size));
    strcat(msg, head_end);
    strcat(msg, payload);

#ifdef DEBUG
    printf(WHITE "sending reply on socket %d\r\n" NEUTRAL, soc);
//    printf("%s", msg);
#endif

    if( send(soc, msg, sizeof(char) * strlen(msg), MSG_EOF) == -1 ) {
        perror(RED "failed to send reply to request" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);
#endif
    
    free(msg);
    //free(payload);
    shutdownSocket(soc);
    return result;
}


/*****************************************************
  *
  * sendStatuReply 
  *
  ***************************************************/
int sendStatusReply(int soc)
{
   int result=0;

#ifdef DEBUG
    printf(WHITE "sending reply on socket %d\r\n" NEUTRAL, soc);
#endif

    char* msg = malloc(sizeof(char) * 3);
    msg[0] = 'O';
    msg[1] = 'K';
    msg[2] = '\n';

    if( send(soc, msg, sizeof(char) * strlen(msg), MSG_EOF) == -1 ) {
        perror(RED "failed to send reply to request" NEUTRAL);
        result = -1;
    }
#ifdef DEBUG
    else
        printf(GREEN "OK\r\n" NEUTRAL);

    free(msg);
    shutdownSocket(soc);
    return result;
#endif
}


/*****************************************************
  *
  * createKml 
  *
  ***************************************************/
int createKml(char** kml)
{
    int result=0;
#ifdef DEBUG
    printf(WHITE "creating KML data \r\n" NEUTRAL);
#endif
    
    kmlify(_kml, _pts);
    *kml = _kml;
    return result;
}

