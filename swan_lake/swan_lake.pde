// Importar librerías de sonido
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
PImage prologoImg, acto1Img, acto2Img, acto3Img, acto4Img;
PImage tituloActo1Img, tituloActo2Img, tituloActo3Img, tituloActo4Img;
PImage pantallaInicialImg, pantallaFinImg;

// Variables botones

// Para el boton de play
PImage botonImg;
float alphaBoton = 0;
float botonX = 650, botonY = 500;
float botonWidth, botonHeight;
float escalaBoton = 1.0;
float escalaBotonHover = 1.2; // Escala cuando el mouse está encima
float botonOriginalWidth, botonOriginalHeight;

// Para los botones de la pantalla final
float botonReiniciarX = 460, botonReiniciarY = 500;
float botonSalirX = 840, botonSalirY = 500;
float escalaBotonReiniciar = 1.0;
float escalaBotonSalir = 1.0;
PImage botonReiniciarImg, botonSalirImg;
boolean mostrandoPantallaFinal = false;

// Variable fuente
PFont miFuente;

// Arreglo de textos de cada escena
String[][] textos = {
  {  // Prologo
    "En una noche, bajo el resplandor de la luna, el malvado hechicero Rothbart transforma a la princesa Odette \nen un cisne.\nSolo un juramento de amor eterno puede romper el hechizo.\nLa historia está a punto de comenzar… \n(Presiona click para continuar)."
  },
  {  // Acto I
    "El joven príncipe Sigfrido está cumpliendo años y celebra la ocasión en el jardín de su bello palacio. \nDe repente el ambiente festivo se ve alterado por la irrupción de la Reina, quien, preocupada por el estilo de \nvida despreocupado de su hijo, le recuerda a su hijo que la noche siguiente deberá escoger una esposa durante \nel baile real de celebración oficial de su cumpleaños.",
    "Sigfrido no se siente preparado para contraer matrimonio, nunca ha experimentado el amor y no quiere \ncasarse con cualquier mujer solo para cumplir con un compromiso como heredero. Conmocionado, se dirige \nsolo al bosque para despejar sus pensamientos. "
  },
  {  // Acto II
    "Sigfrido llega un claro junto al lago. A la distancia, una bandada de cisnes blancos se posa plácidamente. \nÉl apunta con su ballesta a los cisnes, pero, en ese momento, queda cautivado por la imponente y extraña \nbelleza de la mujer más hermosa que jamás ha visto. La joven parece ser, a la vez, cisne y mujer. ",
    "Aquella misteriosa mujer es Odette, la reina cisne. Al ver a Sigfrido queda aterrorizada por su presencia, pero \nél promete no hacerle daño. Ella le cuenta que es víctima de una terrible maldición que la convirtió en un \ncisne para siempre, aunque, cuando la luz del sol se apaga al anochecer, vuelve temporalmente a su forma \nhumana y verdadera, a la orilla del lago encantado creado a partir de las lágrimas derramadas por sus padres.",
    "El príncipe le dice que vaya la próxima noche al baile del palacio, pues debe escoger esposa, y le promete que \nallí le prometerá amor eterno y se casará con ella. En ese momento, el hechicero Rothbart hace señas \namenazadoras a Odette para que regrese al lago."
  },
  {  // Acto III
    "Durante la fiesta de cumpleaños, Sigfrido sólo piensa en la hermosa mujer que encontró en el claro de los \ncisnes y se muestra indiferente ante todas las demás doncellas.",
    "En ese momento el maestro de ceremonias anuncia la llegada de un noble desconocido y su hija. Es el \nmalvado brujo Rothbart, que llega disfrazado a la fiesta con su hija Odile, vestida de un sobrio negro y \nconjurada por el hechicero para ser la viva imagen de Odette. ",
    "Sigfrido, en medio del engaño, jura su amor eterno a la mujer equivocada.",
    "De repente en la ventana del salón aparece la silueta de Odette, quien habia ido al palacio a buscar al príncipe. \nSigfrido se da cuenta de su terrible error y, abatido por el dolor y la culpa, corre desesperado hacia el lago."
  },
  {  // Acto IV
    "A las orillas del lago las jóvenes-cisnes esperan tristemente la llegada de su reina Odette. Ella llega llorando \ndesesperada por la traición de Sigfrido, y les cuenta los tristes acontecimientos de la fiesta en el palacio. \nLas doncellas cisnes tratan de consolarla, pero ella se resigna a la muerte.",
    "Sigfrido irrumpe en el claro. Toma a Odette entre sus brazos y le implora perdón. Ella lo perdona y la \npareja reafirma su amor, pero le dice que no sirve para nada, pues su perdón se corresponde con su muerte. ",
    "Rothbart aparece e insiste en que Sigfrido cumpla su promesa de casarse con su hija Odile, tras lo cual Odette \nse transformará en un cisne para siempre. Sigfrido y Odette luchan contra él, pero todo es en vano, pues el \nmaleficio no puede deshacerse. Odette se da cuenta de que la única manera de salvar, al menos, al resto de las \ndoncellas cisnes será con su muerte.",
    "Y así se lanza del abismo y muere. Sigfrido corre en ayuda de Odette y, junto a ella, se arroja al lago. \nEse sacrificio de amor rompe el hechizo de Rothbart sobre las doncellas cisnes, haciéndole perder su poder \nsobre ellas y morir.",
    "Al amanecer se ve aparecer sobre el lago los espíritus de Odette y Sigfrido ya juntos para siempre \nsubiendo a las regiones celestiales."
  }
};

void setup() {

  size(1300, 700);

  // Iniciar sonido
  minim = new Minim(this);

  // Cargar imágenes
  prologoImg = loadImage("prologo + cuadro de texto.jpg");
  acto1Img = loadImage("acto 1 + cuadro de texto.jpg");
  acto2Img = loadImage("acto 2 + cuadro de texto.jpg");
  acto3Img = loadImage("acto 3 + cuadro de texto.jpg");
  acto4Img = loadImage("acto 4 + cuadro de texto.jpg");

  pantallaInicialImg = loadImage("pantalla de inicio.jpg");
  tituloActo1Img = loadImage("acto 1 + titulo.jpg");
  tituloActo2Img = loadImage("acto 2 + titulo.jpg");
  tituloActo3Img = loadImage("acto 3 + titulo.jpg");
  tituloActo4Img = loadImage("acto 4 + titulo.jpg");
  pantallaFinImg = loadImage("pantalla fin.jpg");

  // Cargar fuente
  miFuente = loadFont("BaskOldFace-48.vlw");
  textFont(miFuente);

  mostrandoPantallaTitulo = true;  // Al inicio muestra la pantalla inicial

  // Empieza la música del acto actual
  cambiarMusicaDelActo();

  botonImg = loadImage("boton play.png"); // Botón de play
  // Guardar tamaño original para usarlo en escalado
  botonOriginalWidth = botonImg.width;
  botonOriginalHeight = botonImg.height;

  botonReiniciarImg = loadImage("boton reiniciar.png");
  botonSalirImg = loadImage("boton salir.png");

  mostrandoPantallaTitulo = true;
  alphaImagen = 0;
  alphaBoton = 0;
}

void draw() {
  background(0);

  if (mostrandoPantallaFinal) {
    // Pantalla final
    image(pantallaFinImg, 0, 0, width, height);

    // Botón Reiniciar
    float reiniciarW = 200 * escalaBotonReiniciar;
    float reiniciarH = 200 * escalaBotonReiniciar;
    float reiniciarXesquina = botonReiniciarX - reiniciarW / 2;
    float reiniciarYesquina = botonReiniciarY - reiniciarH / 2;

    if (mouseX > reiniciarXesquina && mouseX < reiniciarXesquina + reiniciarW &&
      mouseY > reiniciarYesquina && mouseY < reiniciarYesquina + reiniciarH) {
      escalaBotonReiniciar = lerp(escalaBotonReiniciar, 1.2, 0.2);
    } else {
      escalaBotonReiniciar = lerp(escalaBotonReiniciar, 1.0, 0.2);
    }

    image(botonReiniciarImg, reiniciarXesquina, reiniciarYesquina, reiniciarW, reiniciarH);

    // Botón Salir
    float salirW = 200 * escalaBotonSalir;
    float salirH = 200 * escalaBotonSalir;
    float salirXesquina = botonSalirX - salirW / 2;
    float salirYesquina = botonSalirY - salirH / 2;

    if (mouseX > salirXesquina && mouseX < salirXesquina + salirW &&
      mouseY > salirYesquina && mouseY < salirYesquina + salirH) {
      escalaBotonSalir = lerp(escalaBotonSalir, 1.2, 0.2);
    } else {
      escalaBotonSalir = lerp(escalaBotonSalir, 1.0, 0.2);
    }

    image(botonSalirImg, salirXesquina, salirYesquina, salirW, salirH);
  } else if (mostrandoPantallaTitulo) {
    // Pantalla de título por acto
    PImage imgTitulo;

    switch (acto) {
    case 0:
      imgTitulo = pantallaInicialImg;
      break;
    case 1:
      imgTitulo = tituloActo1Img;
      break;
    case 2:
      imgTitulo = tituloActo2Img;
      break;
    case 3:
      imgTitulo = tituloActo3Img;
      break;
    case 4:
      imgTitulo = tituloActo4Img;
      break;
    default:
      imgTitulo = pantallaInicialImg;
      break;
    }

    // Fade-in sincronizado
    if (alphaImagen < 255) {
      alphaImagen += 2;
      alphaBoton += 2;
    }

    alphaImagen = constrain(alphaImagen, 0, 255);
    alphaBoton = constrain(alphaBoton, 0, 255);

    tint(255, alphaImagen);
    image(imgTitulo, 0, 0, width, height);

    // Botón solo en acto 0
    if (acto == 0) {
      float botonWactual = 200 * escalaBoton;
      float botonHactual = 200 * escalaBoton;
      float botonXesquina = botonX - botonWactual / 2;
      float botonYesquina = botonY - botonHactual / 2;

      if (mouseX > botonXesquina && mouseX < botonXesquina + botonWactual &&
        mouseY > botonYesquina && mouseY < botonYesquina + botonHactual) {
        escalaBoton = lerp(escalaBoton, escalaBotonHover, 0.2);
      } else {
        escalaBoton = lerp(escalaBoton, 1.0, 0.2);
      }

      tint(255, alphaBoton);
      image(botonImg, botonXesquina, botonYesquina, botonWactual, botonHactual);
    }
  } else {
    // Mostrar escena del acto
    PImage imgActual = getImagenDelActo();
    tint(255, aplicarFade ? alphaImagen : 255);
    image(imgActual, 0, 0, width, height);

    // Mostrar texto personalizado con el mismo alpha
    mostrarTexto(textos[acto][escena]);

    // Fade-in
    if (aplicarFade && alphaImagen < 255) {
      alphaImagen += 2;
      alphaImagen = constrain(alphaImagen, 0, 255);
    } else if (!aplicarFade) {
      alphaImagen = 255;
    }
  }
}

  void mousePressed() {
    if (mostrandoPantallaFinal) {
      // Verificar clic en botón Reiniciar
      float w = 200 * escalaBotonReiniciar;
      float h = 200 * escalaBotonReiniciar;
      float x = botonReiniciarX - w / 2;
      float y = botonReiniciarY - h / 2;

      if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
        // Reiniciar historia
        acto = 0;
        escena = 0;
        mostrandoPantallaTitulo = true;
        mostrandoPantallaFinal = false;
        alphaImagen = 0;
        alphaBoton = 0;
        cambiarMusicaDelActo();
        return;
      }

      // Verificar clic en botón Salir
      x = botonSalirX - w / 2;
      y = botonSalirY - h / 2;

      if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
        exit(); // Cierra la ventana
        return;
      }
    } else if (mostrandoPantallaTitulo) {

      // Si estamos en el acto 0, solo permitir clic en el botón de inicio
      if (acto == 0) {
        float botonWactual = 200 * escalaBoton;
        float botonHactual = 200 * escalaBoton;
        float botonXesquina = botonX - botonWactual / 2;
        float botonYesquina = botonY - botonHactual / 2;

        boolean clicEnBoton = mouseX > botonXesquina && mouseX < botonXesquina + botonWactual &&
          mouseY > botonYesquina && mouseY < botonYesquina + botonHactual;

        if (clicEnBoton) {
          mostrandoPantallaTitulo = false;
          alphaImagen = 0;
          aplicarFade = necesitaFade(acto, escena);
        }
      } else {
        // Para actos 1 en adelante, cualquier clic entra en la escena
        mostrandoPantallaTitulo = false;
        alphaImagen = 0;
        aplicarFade = necesitaFade(acto, escena);
      }
    } else {
      // Estamos dentro de la historia: avanzar a la siguiente escena
      escena++;

      if (escena >= textos[acto].length) {
        // Terminaron las escenas del acto actual: pasar al siguiente acto
        acto++;
        escena = 0;

        if (acto >= textos.length) {
          // Llegamos al final de la historia: mostrar pantalla final
          mostrandoPantallaFinal = true;
          return;
        }

        cambiarMusicaDelActo();
        mostrandoPantallaTitulo = true;
      }

      alphaImagen = 0;
      aplicarFade = necesitaFade(acto, escena);
    }
  }


  PImage getImagenTitulo() {
    if (acto == 0) return pantallaInicialImg;
    if (acto == 1) return tituloActo1Img;
    if (acto == 2) return tituloActo2Img;
    if (acto == 3) return tituloActo3Img;
    else return tituloActo4Img;
  }

  void mostrarEscena() {
    String texto = textos[acto][escena];

    // Mostrar imagen del acto
    PImage imagenActual = obtenerImagenDelActo(acto);
    image(imagenActual, 0, 0, width, height);

    // Mostrar texto con transparencia si fade in está activado
    if (aplicarFade && necesitaFade(acto, escena)) {
      alphaImagen = min(alphaImagen + 3, 255);
    } else {
      alphaImagen = 255;
    }

    fill(255, alphaImagen); // blanco con alpha
    textFont(miFuente);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(texto, width/2, height - 150);
  }

  PImage obtenerImagenDelActo(int acto) {
    switch(acto) {
    case 0:
      return prologoImg;
    case 1:
      return acto1Img;
    case 2:
      return acto2Img;
    case 3:
      return acto3Img;
    case 4:
      return acto4Img;
    default:
      return null;
    }
  }

  // Muestra el texto en el centro de la pantalla con fade in
  void mostrarTexto(String texto) {
    textFont(miFuente);
    textSize(20); // Ajusta según lo necesites
    textAlign(LEFT, CENTER);
    fill(0, alphaImagen); // Usa alphaImagen aunque no haya fade
    text(texto, 210, 350);
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
