const KSUID = require('ksuid');
function id(tag) { return tag + '_' + KSUID.randomSync().string; }

const personas = [
  { uc: 21, name: "Dr. Emma", type: "Therapist", biz: "Mindful Therapy", slug: "mindful-therapy" },
  { uc: 22, name: "Chef Marco", type: "Private Chef", biz: "Marco's Kitchen", slug: "marcos-kitchen" },
  { uc: 23, name: "Yoga Studio", type: "Wellness Center", biz: "Zen Flow Yoga", slug: "zen-flow-yoga" },
  { uc: 24, name: "Auto Shop", type: "Mechanic", biz: "Quick Fix Motors", slug: "quick-fix-motors" },
  { uc: 25, name: "Photographer", type: "Creative", biz: "Lens and Light", slug: "lens-light" },
  { uc: 26, name: "Consulting Firm", type: "B2B", biz: "StratEdge Consulting", slug: "stratedge" },
  { uc: 27, name: "Vet Clinic", type: "Pet Care", biz: "Paws and Claws", slug: "paws-claws" },
  { uc: 28, name: "Music School", type: "Education", biz: "Harmony Academy", slug: "harmony-academy" },
  { uc: 29, name: "Coworking", type: "Space Rental", biz: "The Hub", slug: "the-hub-coworking" },
  { uc: 30, name: "Cleaning Co", type: "Home Services", biz: "Sparkle Clean", slug: "sparkle-clean" },
  { uc: 31, name: "Language Tutor", type: "Education", biz: "Global Tongues", slug: "global-tongues" },
  { uc: 32, name: "Massage Spa", type: "Wellness", biz: "Serenity Touch", slug: "serenity-touch" },
  { uc: 33, name: "Tax Accountant", type: "Financial", biz: "Number Crunchers", slug: "number-crunchers" },
  { uc: 34, name: "Dance Studio", type: "Arts", biz: "Rhythm Nation", slug: "rhythm-nation" },
  { uc: 35, name: "IT Support", type: "Tech Services", biz: "TechRescue", slug: "techrescue" }
];

const ts = new Date().toISOString().replace(/[-:T.Z]/g, '').slice(0, 14);

personas.forEach(p => {
  const biz = id('biz');
  const loc = id('loc');
  const res = id('res');
  const cal = id('cal');
  const ofr = id('ofr');
  
  const json = {
    defaults: { dryRun: false, scope: { bizId: biz } },
    scenarios: [
      { id: `uc${p.uc}-01`, name: `Create ${p.type} business`, prompt: `insert into bizes id = ${biz} name = ${p.biz} slug = ${p.slug}-${ts} status = active timezone = America/Los_Angeles` },
      { id: `uc${p.uc}-02`, name: 'Create location', prompt: `insert into locations id = ${loc} biz_id = ${biz} name = Main Location slug = main-${p.uc}-${ts} timezone = America/Los_Angeles` },
      { id: `uc${p.uc}-03`, name: `Create ${p.name} as resource`, prompt: `insert into resources id = ${res} biz_id = ${biz} location_id = ${loc} type = host name = ${p.name} slug = ${p.slug}-resource-${ts} timezone = America/Los_Angeles capacity = 1` },
      { id: `uc${p.uc}-04`, name: 'Create calendar', prompt: `insert into calendars id = ${cal} biz_id = ${biz} name = Booking Calendar timezone = America/Los_Angeles slot_duration_min = 60 status = active` },
      { id: `uc${p.uc}-05`, name: 'Create service offer', prompt: `insert into offers id = ${ofr} biz_id = ${biz} type = service name = ${p.type} Service slug = ${p.slug}-offer-${ts} status = active` },
      { id: `uc${p.uc}-06`, name: 'Query business', prompt: `list bizes where id = ${biz}` },
      { id: `uc${p.uc}-07`, name: 'Query resources', prompt: `list resources where biz_id = ${biz}` },
      { id: `uc${p.uc}-08`, name: 'Count offers', prompt: `count offers where biz_id = ${biz}` }
    ]
  };
  
  require('fs').writeFileSync(
    `/Users/ameer/projects/bizing-mind/workspace/agent-api-uc${p.uc}-persona.json`,
    JSON.stringify(json, null, 2)
  );
  console.log(`UC-${p.uc}: ${p.name} (${p.type}) - ${biz}`);
});

console.log(`\nGenerated 15 persona test files with timestamp ${ts}`);
