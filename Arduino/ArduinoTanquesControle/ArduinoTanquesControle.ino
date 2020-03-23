/*
                                    Controle de Tanques Acoplados
                                           Fellipe Bastos: 
                                   catrak@artilhariadigital.com

O código lê os dados de um sensor de pressão, converte para cm e envia via WiFI. Também recebe um valor de 0 - 255
referente a tensão que será aplicada na bomba.

 */
#include <SPI.h>
#include <WiFi.h>
#include <TextFinder.h> // Para procurar um determinado caracter.
int yr= 10; // Referência (setpoint) inicial, caso não tenha sido setado algum no matlab.
int val=0;
int bomba =9;
int EntradaAnalogica1 =0;
int EntradaAnalogica2 =0;
int EntradaAnalogica3 =0;
float pow0;
float pow1;
float pow2;
float pow3;
float pow4;
float pow5;
float NivelTanque1=0.0;
float NivelTanque2=0.0;
double NivelTanque3=0.0;
char ssid[] = "LabAuto";      //  Nome da rede
char pass[] = "LabAuto123";   // Senha da rede


int status = WL_IDLE_STATUS;

WiFiServer server(80);

void setup() {
  Serial.begin(9600); 
  while (!Serial) {
    ; 
  }
  
  // Checa se o modulo WiFi está conectado
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("Modulo Wifi OFF"); 
    // não continua
    while(true);
  } 
  
  // Inicia a conexão com a rede
  while ( status != WL_CONNECTED) { 
    Serial.print("Iniciando conexao com a rede SSID: ");
    Serial.println(ssid);
    // Rede WPA/WPA2. Retire a parte da senha se for uma rede WEP:    
    status = WiFi.begin(ssid, pass);

    // Espera 10 segundos:
    delay(10000);
  } 
  server.begin();
  printWifiStatus();

}


void loop() {

  while (Serial.available() > 0)  {

// Você pode modificar a referência (setpoint) via serial ou via Matlab

    int referencia = Serial.parseInt();

    if ((referencia >= 0 ) && (referencia <30 )) {
     yr = referencia;
     Serial.println(yr); // Recebe a nova referêcia (setpoint)
    }

  }

  // Leitura do sensor 1
  EntradaAnalogica1= analogRead(A0);
  EntradaAnalogica2= analogRead(A1);
  EntradaAnalogica3= analogRead(A2);
  NivelTanque1 = EntradaAnalogica1;
  NivelTanque1 = ((NivelTanque1*5)/1023);
  NivelTanque1 = NivelTanque1*6;
  NivelTanque2 = EntradaAnalogica2;
  NivelTanque2 = ((NivelTanque2*5)/1023);
  NivelTanque2 = NivelTanque2*6;
  //Linearização Polinominal de 5 Ordem do Sensor do Tanque Trapezoidal
    pow5=pow(EntradaAnalogica3,5);
    pow4=pow(EntradaAnalogica3,4);
    pow3=pow(EntradaAnalogica3,3);
    pow2=pow(EntradaAnalogica3,2);
    pow1=pow(EntradaAnalogica3,1);
    pow0=-8.640623008953932;
  NivelTanque3 = ((0.000000000094108)*pow5)+((-0.000000070886966)*pow4)+((0.000020462289992)*pow3)+((-0.002783032703534)*pow2)+((0.289110819198763)*pow1)+pow0+8.64
  ;
  //NivelTanque3 = ((NivelTanque3*5)/1023);
 // NivelTanque3 = NivelTanque3*1; //Relação de Transformação bit - cm do Tanque 3 (Trapezoidal)
  Serial.print(EntradaAnalogica1);
  // Lista os clientes
  WiFiClient client = server.available();
  if (client) {
    TextFinder  finder(client ); 
    //Serial.println("Novo Cliente");
    // Uma solicitação http termina com uma linha em branco
    while (client.connected()) {
      if (client.available()) {
        if(finder.find("GET /")) {
// Vai procurar a palavra tensão e pegar o que vem depois do ?=:
           while(finder.findUntil("tensao", "\n\r")) { 
       
             val = finder.getValue();

           } 
        }

        //Passa uma simples resposta http para o navegador
        printWebResponse(client);
        break;
      }
      
    }
    // Da tempo para o navegador receber os dados
    delay(1);
      // Termina a conexão:
     client.stop();
     //Serial.println("Cliente desconectado");

  }
// Cria limites para os valores de tensão enviados pelo matlab:
 if(val<0){
  val=0;
 }
 if(val>255){
  val=255;
 }

// Ciclo de trabalho que será fornecido para a bomba.
 if(val>0){
              
              Serial.print("Bomba ligada! Valor: ");
             Serial.println(val);
             analogWrite(bomba, val);             
  
 }else{
  Serial.println("Bomba desligada!");
      analogWrite(bomba, 0);
       
 }

  
}


void printWebResponse(WiFiClient client) {
  Serial.println();
  // A solicitação http terminou e será enviado uma resposta
  // Envia uma resposta http padrão com o seguinte cabeçalho.

  client.println("HTTP/1.1 200 OK");
  client.println("Access-Control-Allow-Origin: *");
           client.println("Content-Type: text/html");
  // Não modifique o cabeçalho a cima!

           client.println();
            client.print("<form action=\"/?\" method=get>");
            //client.print("<div align=\"center\">");
            client.print("<b>Nivel_1: </b> "); // Informa o nível do tanque no navegador
            client.print(NivelTanque1);
            client.print("<b>Nivel_2: </b> "); // Informa o nível do tanque no navegador
            client.print(NivelTanque2);
            client.print("<b>Nivel_3: </b> "); // Informa o nível do tanque no navegador
            client.print(NivelTanque3);
            client.print("<b>yr: </b> "); // Informa a referência (setpoint)
            client.print(yr);
            client.println();

}


void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}


