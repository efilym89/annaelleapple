import fs from 'node:fs/promises';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const defaultSourceRoot =
  'C:\\Users\\efily\\Downloads\\anaelacademy\\anaelacademy\\storage';
const repoRoot = process.cwd();
const outputFile = path.join(
  repoRoot,
  'apps',
  'mobile',
  'assets',
  'data',
  'local_content_manifest.json',
);

const dayCopy = {
  'day-1': {
    title: 'День 1',
    subtitle: 'Бренд, клиент и технология',
    description:
      'Первый день знакомит сотрудника с брендом, ролью мастера, ожиданиями клиента и базовой технологией работы.',
  },
  'day-2': {
    title: 'День 2',
    subtitle: 'Продажи и работа с клиентом',
    description:
      'Второй день посвящен продажам, клиентскому контакту, выявлению потребностей, цене, возражениям и завершению сделки.',
  },
};

const companyNews = [
  {
    id: 'news-academy-update',
    title: 'Обновлена программа внутреннего обучения',
    description:
      'Добавили новую структуру прохождения уроков по дням и упростили доступ к материалам для новых сотрудников.',
    dateLabel: 'Сегодня',
  },
  {
    id: 'news-service-standards',
    title: 'Напоминание о стандартах сервиса',
    description:
      'Проверьте актуальные регламенты общения с клиентом и стандарты подготовки кабинета перед сменой.',
    dateLabel: 'Эта неделя',
  },
  {
    id: 'news-team-meeting',
    title: 'Общее собрание команды в пятницу',
    description:
      'Короткая встреча по итогам недели: результаты обучения, обратная связь и приоритеты следующего цикла.',
    dateLabel: 'Пятница',
  },
];

const usefulMaterials = [
  {
    id: 'material-client-script',
    title: 'Памятка по первому контакту с клиентом',
    description:
      'Короткий внутренний материал по приветствию, тону общения и формированию доверия в начале общения.',
    dateLabel: 'Материал',
  },
  {
    id: 'material-cabinet-checklist',
    title: 'Чек-лист подготовки рабочего места',
    description:
      'Быстрая проверка кабинета, материалов и оборудования перед началом рабочего дня.',
    dateLabel: 'Чек-лист',
  },
  {
    id: 'material-service-reminder',
    title: 'Напоминание по стандартам сервиса',
    description:
      'Ключевые моменты, которые важно соблюдать в каждом клиентском сценарии независимо от курса.',
    dateLabel: 'Регламент',
  },
];

function numericSortByName(entries) {
  return [...entries].sort((left, right) => {
    const leftNumber = extractNumericSuffix(left.name);
    const rightNumber = extractNumericSuffix(right.name);
    return leftNumber - rightNumber;
  });
}

function extractNumericSuffix(value) {
  const match = value.match(/(\d+)$/);
  return match ? Number(match[1]) : Number.MAX_SAFE_INTEGER;
}

async function safeReadJson(filePath) {
  const raw = await fs.readFile(filePath, 'utf8');
  return JSON.parse(raw);
}

async function pathExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

function createLessonDescription(title, dayTitle) {
  if (title === 'presentation') {
    return `Урок из блока ${dayTitle} с рабочими материалами и видео.`;
  }

  return `Урок из блока ${dayTitle}, посвященный теме «${title}».`;
}

function buildLessonSummary(title, durationLabel) {
  if (!durationLabel) {
    return `Короткий видеоурок по теме «${title}».`;
  }

  return `Видеоурок по теме «${title}», длительность ${durationLabel}.`;
}

function normalizeUri(filePath) {
  return pathToFileURL(filePath).href;
}

async function buildLesson(dayRoot, dayDirectory, lessonDirectory, dayMeta) {
  const lessonRoot = path.join(dayRoot, lessonDirectory.name);
  const metadataFile = path.join(lessonRoot, 'metadata.json');
  const metadata = await safeReadJson(metadataFile);
  const videoFile = path.join(lessonRoot, 'video.mp4');
  const presentationFile = path.join(lessonRoot, 'presentation.pdf');

  const hasVideo = await pathExists(videoFile);
  const hasPresentation = await pathExists(presentationFile);
  const order = extractNumericSuffix(lessonDirectory.name);

  const title = metadata.title || `Урок ${order}`;
  const durationLabel = metadata.durationLabel || null;

  return {
    id: `${dayDirectory.name}/${lessonDirectory.name}`,
    courseId: dayDirectory.name,
    order,
    title,
    status: metadata.status || 'draft',
    durationLabel,
    summary: buildLessonSummary(title, durationLabel),
    description: createLessonDescription(title, dayMeta.title),
    video: hasVideo
      ? {
          title: 'Видео урока',
          path: videoFile,
          uri: normalizeUri(videoFile),
          durationLabel,
        }
      : null,
    materials: hasPresentation
      ? [
          {
            id: `${dayDirectory.name}/${lessonDirectory.name}/presentation`,
            type: 'presentation',
            title: 'Презентация урока',
            path: presentationFile,
            uri: normalizeUri(presentationFile),
          },
        ]
      : [],
  };
}

function sumDurations(lessons) {
  let totalSeconds = 0;

  for (const lesson of lessons) {
    if (!lesson.durationLabel) {
      continue;
    }

    const match = lesson.durationLabel.match(/^(\d{2}):(\d{2})$/);
    if (!match) {
      continue;
    }

    totalSeconds += Number(match[1]) * 60 + Number(match[2]);
  }

  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
}

async function buildCourse(sourceRoot, dayDirectory) {
  const dayMeta = dayCopy[dayDirectory.name] || {
    title: dayDirectory.name,
    subtitle: 'Учебный день',
    description: 'Учебные материалы дня.',
  };

  const lessonDirectories = numericSortByName(
    (await fs.readdir(path.join(sourceRoot, dayDirectory.name), {
      withFileTypes: true,
    })).filter((entry) => entry.isDirectory()),
  );

  const lessons = [];

  for (const lessonDirectory of lessonDirectories) {
    lessons.push(
      await buildLesson(
        path.join(sourceRoot, dayDirectory.name),
        dayDirectory,
        lessonDirectory,
        dayMeta,
      ),
    );
  }

  return {
    id: dayDirectory.name,
    title: dayMeta.title,
    subtitle: dayMeta.subtitle,
    description: dayMeta.description,
    lessonCount: lessons.length,
    totalDurationLabel: sumDurations(lessons),
    lessons,
  };
}

async function main() {
  const sourceRoot = process.env.ANAEL_STORAGE_ROOT || defaultSourceRoot;
  const dayDirectories = numericSortByName(
    (await fs.readdir(sourceRoot, { withFileTypes: true })).filter((entry) =>
      entry.isDirectory(),
    ),
  );

  const courses = [];

  for (const dayDirectory of dayDirectories) {
    courses.push(await buildCourse(sourceRoot, dayDirectory));
  }

  const manifest = {
    generatedAt: new Date().toISOString(),
    sourceRoot,
    courses,
    companyNews,
    usefulMaterials,
  };

  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(manifest, null, 2)}\n`, 'utf8');

  process.stdout.write(`Manifest written to ${outputFile}\n`);
}

main().catch((error) => {
  process.stderr.write(`${error instanceof Error ? error.stack : String(error)}\n`);
  process.exitCode = 1;
});
