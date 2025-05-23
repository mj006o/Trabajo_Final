// Importar librerías
import ddf.minim.*;
import ddf.minim.analysis.*;

// Variables de sonido
Minim minim;
AudioPlayer player;

// Variables de historia
int acto = 0;  // Acto actual

int escena = 0;  // Escena actual dentro del acto

float alphaImagen = 0; // Transición fade in, nivel de transparencia de la imagen o texto

boolean mostrandoPantallaTitulo = true; // Mostrar la pantalla del titulo del acto

// Controlar si se debe aplicar el efecto de fade in en esa escena.
boolean aplicarFade = true; 
boolean necesitaFade(int acto, int escena) {
  // Lista de escenas que NO deben tener fade in
  return !(
    (acto == 1 && escena == 1) ||  // Escena 2
    (acto == 2 && escena == 1) ||  // Escena 4
    (acto == 2 && escena == 2) ||  // Escena 5
    (acto == 3 && escena == 1) ||  // Escena 7
    (acto == 3 && escena == 2) ||  // Escena 8
    (acto == 3 && escena == 3) ||  // Escena 9
    (acto == 4 && escena == 1) ||  // Escena 11
    (acto == 4 && escena == 2) ||  // Escena 12
    (acto == 4 && escena == 3)     // Escena 13
    );
}

// Variables imágenes
PImage prologoImg, acto1Img, acto2Img, acto3Img, acto4Img, pantallaInicialImg, tituloActo1Img, tituloActo2Img, tituloActo3Img, tituloActo4Img;

// Arreglo de textos de cada escena
String[][] textos = {
  {  // Prologo
    "En una noche, bajo el resplandor de la luna, el malvado hechicero Rothbart transforma a la princesa Odette en un cisne.\nSolo un juramento de amor eterno puede romper el hechizo.\nLa historia está a punto de comenzar…"
  },
  {  // Acto I
    "El joven príncipe Sigfrido está cumpliendo años y celebra la ocasión en el jardín de su bello palacio. De repente el ambiente festivo se ve alterado por la irrupción de la Reina, quien, preocupada por el estilo de vida despreocupado de su hijo, le recuerda a su hijo que la noche siguiente deberá escoger una esposa durante el baile real de celebración oficial de su cumpleaños.",
    "Sigfrido no se siente preparado para contraer matrimonio, nunca ha experimentado el amor y no quiere casarse con cualquier mujer solo para cumplir con un compromiso como heredero. Conmocionado, se dirige solo al bosque para despejar sus pensamientos. "
  },
  {  // Acto II
    "Sigfrido llega un claro junto al lago. A la distancia, una bandada de cisnes blancos se posa plácidamente. Él apunta con su ballesta a los cisnes, \npero, en ese momento, queda cautivado por la imponente y extraña belleza de la mujer más hermosa que jamás ha visto. La joven parece ser, a la vez, cisne y mujer. ",
    "Aquella misteriosa mujer es Odette, la reina cisne. Al ver a Sigfrido queda aterrorizada por su presencia, pero él promete no hacerle daño. Ella le cuenta que es víctima de una terrible maldición que la convirtió en un cisne para siempre, aunque, cuando la luz del sol se apaga al anochecer, vuelve temporalmente a su forma humana y verdadera, a la orilla del lago encantado creado a partir de las lágrimas derramadas por sus padres.",
    "El príncipe le dice que vaya la próxima noche al baile del palacio, pues debe escoger esposa, y le promete que allí le prometerá amor eterno y se \ncasará con ella. En ese momento, el hechicero Rothbart hace señas amenazadoras a Odette para que regrese al lago."
  },
  {  // Acto III
    "Durante la fiesta de cumpleaños, Sigfrido sólo piensa en la hermosa mujer que encontró en el claro de los cisnes y se muestra indiferente ante todas las demás doncellas.",
    "En ese momento el maestro de ceremonias anuncia la llegada de un noble desconocido y su hija. Es el malvado brujo Rothbart, que llega disfrazado a la fiesta con su hija Odile, vestida de un sobrio negro y conjurada por el hechicero para ser la viva imagen de Odette. ",
    "Sigfrido, en medio del engaño, jura su amor eterno a la mujer equivocada.",
    "De repente en la ventana del salón aparece la silueta de Odette, quien habia ido al palacio a buscar al príncipe. Sigfrido se da cuenta de su terrible error y, abatido por el dolor y la culpa, corre desesperado hacia el lago."
  },
  {  // Acto IV
    "A las orillas del lago las jóvenes-cisnes esperan tristemente la llegada de su reina Odette. Ella llega llorando desesperada por la traición de Sigfrido, y les cuenta los tristes acontecimientos de la fiesta en el palacio. Las doncellas cisnes tratan de consolarla, pero ella se resigna a la muerte.",
    "Sigfrido irrumpe en el claro. Toma a Odette entre sus brazos y le implora perdón. Ella lo perdona y la pareja reafirma su amor, pero le dice que no sirve para nada, pues su perdón se corresponde con su muerte. ",
    "Rothbart aparece e insiste en que Sigfrido cumpla su promesa de casarse con su hija Odile, tras lo cual Odette se transformará en un cisne para siempre. Sigfrido y Odette luchan contra él, pero todo es en vano, pues el maleficio no puede deshacerse. Odette se da cuenta de que la única manera de salvar, al menos, al resto de las doncellas cisnes será con su muerte.",
    "Y así se lanza del abismo y muere. Sigfrido corre en ayuda de Odette y, junto a ella, se arroja al lago. Ese sacrificio de amor rompe el hechizo de Rothbart sobre las doncellas cisnes, haciéndole perder su poder sobre ellas y morir.",
    "Al amanecer se ve aparecer sobre el lago los espíritus de Odette y Sigfrido ya juntos para siempre subiendo a las regiones celestiales."
  }
};

void setup() {

  size(1300, 700);
  
  // Iniciar sonido
  minim = new Minim(this);

  // Cargar imágenes
  prologoImg = loadImage("Prologo mientras.png");
  acto1Img = loadImage("boceto fondo acto 1.jpg");
  acto2Img = loadImage("boceto fondo acto 2.jpg");
  acto3Img = loadImage("boceto fondo acto 3.jpg");
  acto4Img = loadImage("boceto fondo acto 4.jpg");

  pantallaInicialImg = loadImage("boceto pantalla inicial.jpg");
  tituloActo1Img = loadImage("boceto fondo acto 1 + titulo.jpg");
  tituloActo2Img = loadImage("boceto fondo acto 2 + titulo.jpg");
  tituloActo3Img = loadImage("boceto fondo acto 3 + titulo.jpg");
  tituloActo4Img = loadImage("boceto fondo acto 4 + titulo.jpg");

  mostrandoPantallaTitulo = true;  // Al inicio muestra la pantalla inicial

  // Empieza la música del acto actual
  cambiarMusicaDelActo();
}

void draw() {
  background(0);

  if (mostrandoPantallaTitulo) {
    // Mostrar imagen de título con fade in
    PImage tituloImg = getImagenTitulo();
    tint(255, alphaImagen); // Transparencia
    image(tituloImg, 0, 0, width, height);

    if (aplicarFade && alphaImagen < 255) {
      alphaImagen += 2;
    }
  } else {
    // Mostrar imagen y texto de escena
    PImage imgActual = getImagenDelActo();
    tint(255, aplicarFade ? alphaImagen : 255);
    image(imgActual, 0, 0, width, height);
    mostrarTexto(textos[acto][escena]);

    if (aplicarFade && alphaImagen < 255) {
      alphaImagen += 2;
    }
  }
}

void mousePressed() {
  if (mostrandoPantallaTitulo) {
    mostrandoPantallaTitulo = false;
    alphaImagen = 0;
    aplicarFade = true;
    return;
  }

  // Avanzar escena cuando se hace clic
  escena++;
  if (escena >= textos[acto].length) {
    acto++;
    escena = 0;

    if (acto > 4) acto = 0;  // Reiniciar si pasa del acto IV

    cambiarMusicaDelActo();
    mostrandoPantallaTitulo = true;
    aplicarFade = true;
    alphaImagen = 0;
  } else {
    aplicarFade = necesitaFade(acto, escena);
    alphaImagen = aplicarFade ? 0 : 255;
  }
}


PImage getImagenTitulo() {
  if (acto == 0) return pantallaInicialImg;
  if (acto == 1) return tituloActo1Img;
  if (acto == 2) return tituloActo2Img;
  if (acto == 3) return tituloActo3Img;
  else return tituloActo4Img;
}

// Muestra el texto en pantalla con fade in
void mostrarTexto(String texto) {
  fill(0, alphaImagen);
  textSize(20);
  textAlign(LEFT, CENTER);  // Alineado a la derecha
  textLeading(40);
  text(texto, 20, 450, width - 50, 250);  // Más arriba y a la derecha
}

PImage getImagenDelActo() {
  if (acto == 0) return prologoImg;
  if (acto == 1) return acto1Img;
  if (acto == 2) return acto2Img;
  if (acto == 3) return acto3Img;
  else return acto4Img;
}

// Reproduce la música correspondiente al acto actual
void cambiarMusicaDelActo() {
  if (player != null) player.close(); // Cierra la música anterior

  if (acto == 0) player = minim.loadFile("Swan-Lake-19-No.-10-Moderato.mp3");
  else if (acto == 1) player = minim.loadFile("Swan-Lake-03-No.-2-Valse.mp3");
  else if (acto == 2) player = minim.loadFile("Swan-Lake-Act-II-pas-de-deux-.mp3");
  else if (acto == 3) player = minim.loadFile("Swan-Lake-33-No.-18-Scene-_black-swan_.mp3");
  else player = minim.loadFile("Swan-Lake-46-Act-IV-No.-29-Finale.mp3");

  player.play();
}
