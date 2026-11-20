# PAIR.md — Tech Hiring Pulse

## Week 1 — Choosing Our Project

When we first started thinking about our project, we wanted to choose something that connects to our lives today and could also be useful for other students in our degree.

We discussed different ideas and tried to understand which topics interested us the most and could provide value to students, especially those who are starting to think about their future careers.

After choosing our preferred direction, we started checking whether the project was actually possible. We looked at the available data sources, the information we could collect and the storage limitations of the course.

We also started looking for companies that matched our conditions, since we wanted to work with a specific group of technology companies rather than collect random job postings.

At this stage, we worked together on the project ideas, the initial research and the company selection.

## Week 2 — Planning and Preparation

After Tech Hiring Pulse was approved, we went through the updated project instructions together and started preparing for the first data collection.

We wanted to understand the requirements in advance, especially how to save the data and collect snapshots on different days with a one-day interval between them.

During our preparation, several questions came up. We contacted our lecturer to clarify some of the requirements and make sure we were approaching the project correctly.

One of our main challenges was understanding how to collect data only from the companies we had selected. We wanted to follow the same companies over time so that we could identify changes in their job postings.

We used AI tools to help us understand how to do this using Bash and curl, while keeping the process simple and following the course instructions.

We also checked different ways of storing and compressing the data because we needed to stay within the 500 MB storage limit.

By the end of this stage, we had selected 54 companies represented by 55 Greenhouse job boards and prepared for the first collection.

We worked together on understanding the requirements, choosing the companies and planning the collection process.

## Week 3 — Data Collection

We started collecting data from Greenhouse on November 17, 2026.

We divided the collection work between us as follows:

| Date | Responsible |
|---|---|
| November 17, 2026 | Yoav and Hili |
| November 18, 2026 | Hili |
| November 19, 2026 | Hili |
| November 20, 2026 | Yoav |

On the first day, we worked together to perform the first collection and check that the information was saved correctly.

On the second and third days, Hili was responsible for running the collection and saving the snapshots.

On the fourth day, Yoav ran the collection again. During this process, we found that the script had saved the data outside the main project folder. After checking the file location, we copied the snapshot into the correct folder and uploaded it to GitHub.

We also updated SOURCE.md to describe the data we collected and the schema we plan to use later in the project.

The four snapshots gave us our first set of data that we can compare as the project continues.

## AI Assistance

We used AI tools mainly to understand the technical requirements, plan the collection process and get help with Bash commands and troubleshooting.

Below are two reconstructed prompts that summarize the main requests we made while planning and preparing the project. They are not exact copies of the original conversations.

### Prompt 1 — Project Planning

"אנחנו יואב קידר והילי נץ, סטודנטים בקורס יסודות טכנולוגיית מידע ומערכות מידע עסקיות.

לאחרונה קיבלנו אישור לפרויקט שלנו, Tech Hiring Pulse, ואנחנו רוצים לתכנן בצורה מסודרת איך נבצע אותו לאורך הסמסטר.

המטרה שלנו היא לאסוף נתונים על משרות פתוחות בחברות טכנולוגיה, לעקוב אחר השינויים בהן לאורך זמן ולנסות לזהות מגמות בגיוסים, במיוחד במשרות שיכולות להיות רלוונטיות לסטודנטים ולאנשים בתחילת הקריירה שלהם.

אנחנו מעוניינים להשתמש בנתונים שמגיעים מ־Greenhouse, אבל חשוב לנו לאסוף מידע רק מחברות מסוימות שנבחר בעצמנו, כדי שנוכל לעקוב אחר אותה קבוצת חברות לאורך כל הפרויקט.

נרצה שתעזור לנו להבין איך ניתן לבצע את הפרויקט מבחינה טכנית, איך לבחור חברות שמתאימות למחקר ואיך לארגן את הנתונים כך שנוכל להשוות בין דגימות שנאסוף בימים שונים.

בנוסף, חשוב לנו לעמוד בכל הדרישות של הקורס, כולל שימוש בלינוקס, Bash, curl ו־Git, שמירה של נתונים גולמיים ללא שינוי, שימוש בשעון UTC ומגבלת אחסון של 500MB לכל הסמסטר.

אנחנו עדיין בשלבים הראשונים של העבודה עם הכלים האלה, ולכן נשמח להסבר פשוט וברור של האפשרויות הקיימות, היתרונות והחסרונות שלהן, והמלצה על דרך עבודה שתהיה יעילה אבל גם מספיק פשוטה כדי שנוכל להבין ולתחזק אותה בעצמנו."

### Prompt 2 — Building the Data Collection Script

"אנחנו יואב קידר והילי נץ, סטודנטים בקורס יסודות טכנולוגיית מידע ומערכות מידע עסקיות, ועובדים יחד על פרויקט Tech Hiring Pulse.

לאחר בדיקה וסינון של החברות הרלוונטיות, בחרנו 54 חברות טכנולוגיה שמיוצגות באמצעות 55 לוחות משרות ב־Greenhouse.

אנחנו רוצים לבנות סקריפט Bash שיאפשר לנו לאסוף נתוני משרות רק מהחברות שבחרנו, באמצעות Greenhouse API והפקודה curl.

חשוב לנו שהסקריפט יקרא את רשימת החברות מקובץ טקסט נפרד, יעבור על הלוחות אחד אחרי השני, וישמור את הנתונים שהתקבלו בצורה מסודרת.

אנחנו רוצים שהסקריפט יבדוק אם הבקשות הצליחו, יזהה תקלות ויבדיל בין חברה שאין לה כרגע משרות פתוחות לבין בקשה שנכשלה מסיבה טכנית.

בנוסף, צריך לשמור לכל דגימה תאריך ושעה לפי UTC, כדי שנוכל להשוות בין הנתונים שנאספו בימים שונים.

אנחנו צריכים לשמור את הנתונים בתיקיית raw, בלי לשנות או למחוק דגימות קודמות, ולוודא שהקבצים נשמרים בצורה תקינה לפני שאנחנו מעלים אותם ל־GitHub.

מכיוון שיש לנו מגבלת אחסון של 500MB, נרצה גם להבין איך אפשר לדחוס את הנתונים באמצעות gzip או xz, ומה היתרונות של כל אפשרות.

נשמח שתעזור לנו לבנות את הסקריפט באמצעות כלים סטנדרטיים של לינוקס, בעיקר Bash, curl ו־jq.

חשוב לנו שהפתרון לא יהיה מסובך מדי, ושנסיים עם סקריפט שאנחנו באמת מבינים איך הוא עובד. לכן נרצה גם הסבר של השלבים המרכזיים, כיצד מריצים אותו, איך בודקים שהתוצאה תקינה ואיך מתמודדים עם שגיאות אפשריות."

### How We Used AI

The AI tools helped us understand different ways to approach the project and suggested solutions for the technical parts.

We used them to help with the collection script, Bash commands, Git operations and troubleshooting. We also used ChatGPT to help organize and edit parts of our project documentation.

We checked the commands and results ourselves and made adjustments when something did not work as expected.

The actual data collection and Git operations were performed by us on our computers.
