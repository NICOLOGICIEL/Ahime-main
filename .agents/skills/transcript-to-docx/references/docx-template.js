/**
 * GABARIT — Transcript technique → document Word complet
 *
 * Usage : copier ce fichier, remplacer les constantes de style si besoin,
 * puis remplir le tableau `children` de la section avec les helpers
 * ci-dessous (h1, h2, h3, p, bullet, codeBlock, codeLabel, calloutTip,
 * comparisonTable) en suivant le plan établi à l'étape 1 du skill.
 *
 * Rappel des gotchas docx-js (voir /mnt/skills/public/docx/SKILL.md) :
 * - Page A4 par défaut ; pour US Letter, changer page.size.
 * - Tables : columnWidths sur la table ET width sur chaque cellule, en DXA.
 * - Shading : toujours ShadingType.CLEAR, jamais SOLID (rendu noir sinon).
 * - Listes : jamais de "•" en dur, utiliser numbering + LevelFormat.BULLET.
 * - Jamais de "\n" : un Paragraph par ligne.
 * - PageBreak doit être à l'intérieur d'un Paragraph.
 */

const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, Table, TableRow, TableCell,
  WidthType, ShadingType, BorderStyle, AlignmentType, LevelFormat, PageBreak,
} = require("docx");

// ---------- charte graphique (à adapter au sujet) ----------
const FONT = "Calibri";
const MONO = "Consolas";
const ACCENT = "1F4E5F";       // couleur d'accent (titres, en-têtes de tableau)
const ACCENT_LIGHT = "EAF1F3"; // fond des encadrés "À retenir"
const GREY = "595959";
const CODE_BG = "F4F4F4";
const CODE_BORDER = "D0D0D0";

// ---------- helpers de contenu ----------

function h1(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 400, after: 200 },
    border: { bottom: { color: ACCENT, space: 4, style: BorderStyle.SINGLE, size: 6 } },
    children: [new TextRun({ text, bold: true, color: ACCENT, size: 30, font: FONT })],
  });
}

function h2(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 300, after: 150 },
    children: [new TextRun({ text, bold: true, color: ACCENT, size: 24, font: FONT })],
  });
}

function h3(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_3,
    spacing: { before: 200, after: 100 },
    children: [new TextRun({ text, bold: true, color: "333333", size: 21, font: FONT })],
  });
}

// texte courant ; passer { italics: true } etc. en second argument si besoin
function p(text, opts = {}) {
  return new Paragraph({
    spacing: { after: 160, line: 300 },
    children: [new TextRun({ text, size: 21, font: FONT, ...opts })],
  });
}

function bullet(text, level = 0) {
  return new Paragraph({
    numbering: { reference: "bullets", level },
    spacing: { after: 80 },
    children: [new TextRun({ text, size: 21, font: FONT })],
  });
}

// encadré "À retenir" — un maximum par section, réservé aux points vraiment clés
function calloutTip(text) {
  return new Paragraph({
    spacing: { before: 100, after: 200 },
    shading: { type: ShadingType.CLEAR, fill: ACCENT_LIGHT },
    border: { left: { color: ACCENT, space: 8, style: BorderStyle.SINGLE, size: 24 } },
    indent: { left: 200 },
    children: [
      new TextRun({ text: "À retenir — ", bold: true, size: 20, font: FONT, color: ACCENT }),
      new TextRun({ text, size: 20, font: FONT, color: "333333" }),
    ],
  });
}

// bloc de code : lines = tableau de chaînes, une par ligne (jamais de \n interne)
function codeBlock(lines) {
  return new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    borders: {
      top: { style: BorderStyle.SINGLE, size: 4, color: CODE_BORDER },
      bottom: { style: BorderStyle.SINGLE, size: 4, color: CODE_BORDER },
      left: { style: BorderStyle.SINGLE, size: 4, color: CODE_BORDER },
      right: { style: BorderStyle.SINGLE, size: 4, color: CODE_BORDER },
      insideHorizontal: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
      insideVertical: { style: BorderStyle.NONE, size: 0, color: "FFFFFF" },
    },
    rows: [
      new TableRow({
        children: [
          new TableCell({
            shading: { type: ShadingType.CLEAR, fill: CODE_BG },
            margins: { top: 120, bottom: 120, left: 160, right: 160 },
            children: lines.map(
              (line) =>
                new Paragraph({
                  spacing: { after: 0 },
                  children: [new TextRun({ text: line.length ? line : " ", font: MONO, size: 18, color: "1B1B1B" })],
                })
            ),
          }),
        ],
      }),
    ],
  });
}

// légende posée juste avant un codeBlock (ex. "Configuration .env :")
function codeLabel(text) {
  return new Paragraph({
    spacing: { before: 120, after: 60 },
    children: [new TextRun({ text, italics: true, size: 19, font: FONT, color: GREY })],
  });
}

// tableau comparatif — colWidths en DXA, doit sommer à la largeur utile de page
function comparisonTable(headers, rows, colWidths) {
  const totalWidth = colWidths.reduce((a, b) => a + b, 0);
  const header = new TableRow({
    tableHeader: true,
    children: headers.map(
      (t, i) =>
        new TableCell({
          width: { size: colWidths[i], type: WidthType.DXA },
          shading: { type: ShadingType.CLEAR, fill: ACCENT },
          margins: { top: 100, bottom: 100, left: 120, right: 120 },
          children: [new Paragraph({ children: [new TextRun({ text: t, bold: true, color: "FFFFFF", size: 19, font: FONT })] })],
        })
    ),
  });
  const body = rows.map(
    (r, ri) =>
      new TableRow({
        children: r.map(
          (t, i) =>
            new TableCell({
              width: { size: colWidths[i], type: WidthType.DXA },
              shading: { type: ShadingType.CLEAR, fill: ri % 2 === 0 ? "FFFFFF" : "F7F9FA" },
              margins: { top: 90, bottom: 90, left: 120, right: 120 },
              children: [new Paragraph({ children: [new TextRun({ text: t, size: 19, font: FONT })] })],
            })
        ),
      })
  );
  return new Table({
    width: { size: totalWidth, type: WidthType.DXA },
    columnWidths: colWidths,
    rows: [header, ...body],
  });
}

function pageBreak() {
  return new Paragraph({ children: [new PageBreak()] });
}

// ---------- squelette de document ----------

const doc = new Document({
  styles: { default: { document: { run: { font: FONT, size: 21 } } } },
  numbering: {
    config: [
      {
        reference: "bullets",
        levels: [
          { level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 420, hanging: 260 } } } },
          { level: 1, format: LevelFormat.BULLET, text: "◦", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 760, hanging: 260 } } } },
        ],
      },
    ],
  },
  sections: [
    {
      properties: {
        page: {
          size: { width: 11906, height: 16838 }, // A4 — 12240x15840 pour US Letter
          margin: { top: 1000, bottom: 1000, left: 1100, right: 1100 },
        },
      },
      children: [
        // ---- Page de titre ----
        new Paragraph({ spacing: { before: 2000 }, alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: "TITRE DU DOCUMENT", bold: true, size: 40, color: ACCENT, font: FONT })] }),
        new Paragraph({ spacing: { before: 200, after: 3200 }, alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: "Sous-titre / accroche", size: 24, color: "333333", font: FONT, italics: true })] }),
        pageBreak(),

        // ---- Sommaire ----
        h1("Sommaire"),
        bullet("1. Première section"),
        bullet("2. Deuxième section"),
        pageBreak(),

        // ---- Contenu ----
        // À remplir : h1/h2/h3, p, bullet, codeLabel + codeBlock, comparisonTable,
        // calloutTip, pageBreak() avant chaque section majeure — cf. étape 3 du skill.
      ],
    },
  ],
});

Packer.toBuffer(doc).then((buf) => {
  require("fs").writeFileSync("/home/claude/doc/output.docx", buf);
  console.log("done");
});
