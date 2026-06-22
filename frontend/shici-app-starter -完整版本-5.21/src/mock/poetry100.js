// src/mock/poetry100.js

const basePoems = [
  {
    title: "静夜思",
    author: "李白",
    dynasty: "唐",
    line: "举头望明月，低头思故乡。",
    meaning:
      "抬头看着天上的明月，低头便想起远方的家乡，表达了诗人深深的思乡之情。",
    appreciation:
      "这两句诗语言朴素自然，却极富感染力。诗人借“明月”这一经典意象，将夜晚的寂静、旅途的孤独与浓烈的乡愁融为一体，是中国古典诗歌中最脍炙人口的思乡名句之一。",
    tag: "思乡",
    theme: "月夜思乡",
    level: "入门",
    keywords: ["明月", "思乡", "夜晚", "乡愁"],
    cover: "",
  },
  {
    title: "春晓",
    author: "孟浩然",
    dynasty: "唐",
    line: "春眠不觉晓，处处闻啼鸟。",
    meaning:
      "春天睡觉格外香甜，不知不觉天就亮了，到处都能听到鸟儿的叫声。",
    appreciation:
      "这两句抓住了春晨最富代表性的感受：睡意未散、鸟鸣四起。诗人没有直接写春色，却通过“眠”与“啼鸟”让读者感受到春天的生机与温柔，具有含蓄而鲜活的审美效果。",
    tag: "春景",
    theme: "春日晨景",
    level: "入门",
    keywords: ["春天", "鸟鸣", "清晨", "自然"],
    cover: "",
  },
  {
    title: "登鹳雀楼",
    author: "王之涣",
    dynasty: "唐",
    line: "欲穷千里目，更上一层楼。",
    meaning:
      "想要看得更远、更广，就要再登上一层楼。",
    appreciation:
      "诗句由写景升华为哲理，既写登高远望的真实体验，也寓意人要不断提升自己，才能拥有更开阔的眼界。语言简练，意境高远，常被用来鼓励人积极进取。",
    tag: "哲理",
    theme: "登高望远",
    level: "入门",
    keywords: ["登高", "远望", "志向", "哲理"],
    cover: "",
  },
  {
    title: "望岳",
    author: "杜甫",
    dynasty: "唐",
    line: "会当凌绝顶，一览众山小。",
    meaning:
      "终有一天要登上泰山最高峰，俯视群山，觉得它们都显得渺小。",
    appreciation:
      "这两句写出了青年杜甫昂扬豪迈的精神气象。它不仅写登山的气势，更表达出诗人胸怀天下、积极进取的壮志，是中国诗歌中极具力量感的名句。",
    tag: "壮志",
    theme: "凌云之志",
    level: "进阶",
    keywords: ["泰山", "志向", "豪迈", "进取"],
    cover: "",
  },
  {
    title: "送杜少府之任蜀州",
    author: "王勃",
    dynasty: "唐",
    line: "海内存知己，天涯若比邻。",
    meaning:
      "只要四海之内还有知己好友，即使远在天涯，也像近邻一样亲近。",
    appreciation:
      "这句一扫离别诗中常见的低沉伤感，展现出豁达开朗的情怀。真正的友情不会因为距离而消减，反而因相知而更加珍贵，因此千百年来广为传诵。",
    tag: "友情",
    theme: "送别友情",
    level: "入门",
    keywords: ["知己", "友情", "送别", "豁达"],
    cover: "",
  },
  {
    title: "题西林壁",
    author: "苏轼",
    dynasty: "宋",
    line: "不识庐山真面目，只缘身在此山中。",
    meaning:
      "看不清庐山真正的全貌，只因为自己正处在庐山之中。",
    appreciation:
      "诗人由观山引出哲理：人常常因为身处局中而难以全面看清事物。这种“当局者迷”的思想，借自然之景表达得十分巧妙，是宋诗中融理入诗的典型代表。",
    tag: "哲理",
    theme: "观景明理",
    level: "进阶",
    keywords: ["庐山", "角度", "哲理", "认识"],
    cover: "",
  },
  {
    title: "游山西村",
    author: "陆游",
    dynasty: "宋",
    line: "山重水复疑无路，柳暗花明又一村。",
    meaning:
      "山峦重叠，流水曲折，正在怀疑前面没有路时，忽然又出现了一个村庄。",
    appreciation:
      "这两句本写乡间行路的惊喜体验，却因其蕴含的“绝处逢生、困境转机”的意味而成为千古名句。语言明快，画面感强，极富启发意义。",
    tag: "励志",
    theme: "困境转机",
    level: "进阶",
    keywords: ["山水", "转机", "希望", "励志"],
    cover: "",
  },
  {
    title: "水调歌头",
    author: "苏轼",
    dynasty: "宋",
    line: "但愿人长久，千里共婵娟。",
    meaning:
      "只希望亲人朋友都能平安长久，即使相隔千里，也能共同欣赏这美好的月亮。",
    appreciation:
      "这句将中秋月夜的离愁转化为旷达温暖的祝愿，体现出苏轼博大的情怀。它不仅写亲情友情，也表达了中国人对团圆、平安、长久的共同期盼。",
    tag: "祝愿",
    theme: "中秋望月",
    level: "入门",
    keywords: ["中秋", "月亮", "祝福", "团圆"],
    cover: "",
  },
  {
    title: "将进酒",
    author: "李白",
    dynasty: "唐",
    line: "天生我材必有用，千金散尽还复来。",
    meaning:
      "上天既然赋予我才能，就一定有它的用处；即使千金散去，也还会再回来。",
    appreciation:
      "诗句充满强烈的自信与豪放气概，表达了李白蔑视世俗、相信自身价值的精神力量。读来酣畅淋漓，极具鼓舞人心的效果。",
    tag: "自信",
    theme: "豪情自勉",
    level: "进阶",
    keywords: ["自信", "豪放", "价值", "李白"],
    cover: "",
  },
  {
    title: "行路难",
    author: "李白",
    dynasty: "唐",
    line: "长风破浪会有时，直挂云帆济沧海。",
    meaning:
      "总有一天能够乘长风破万里浪，高挂云帆，横渡沧海，实现理想。",
    appreciation:
      "这两句写尽人生逆境中的坚持与希望。尽管现实坎坷，但诗人始终相信未来可期，体现出积极昂扬的奋斗精神，是极具感染力的励志名句。",
    tag: "励志",
    theme: "逆境奋进",
    level: "进阶",
    keywords: ["理想", "奋斗", "希望", "逆境"],
    cover: "",
  },
  {
    title: "凉州词",
    author: "王之涣",
    dynasty: "唐",
    line: "黄河远上白云间，一片孤城万仞山。",
    meaning:
      "黄河仿佛从白云之间奔流而来，一座孤城矗立在高耸入云的群山之间。",
    appreciation:
      "这两句开篇极具空间纵深感，勾勒出边塞地区雄浑苍凉的壮阔图景。诗人以大笔写大景，为全诗奠定了辽远而悲壮的基调。",
    tag: "边塞",
    theme: "边关雄景",
    level: "进阶",
    keywords: ["黄河", "孤城", "边塞", "壮阔"],
    cover: "",
  },
  {
    title: "钱塘湖春行",
    author: "白居易",
    dynasty: "唐",
    line: "乱花渐欲迷人眼，浅草才能没马蹄。",
    meaning:
      "五颜六色的春花渐渐让人看花了眼，刚刚长出的浅草将将能够遮没马蹄。",
    appreciation:
      "诗人通过“乱花”“浅草”抓住西湖早春最鲜活的景物特征，色彩明丽，节奏轻快，体现了春日出游时的欣喜心情，也让画面显得灵动可爱。",
    tag: "春景",
    theme: "西湖踏春",
    level: "入门",
    keywords: ["西湖", "花草", "春游", "白居易"],
    cover: "",
  },
  {
    title: "饮酒·其五",
    author: "陶渊明",
    dynasty: "晋",
    line: "采菊东篱下，悠然见南山。",
    meaning:
      "在东边篱笆下采摘菊花，悠然自得地望见远处的南山。",
    appreciation:
      "这两句是田园诗的典范，呈现出诗人远离尘嚣、回归自然后的宁静心境。其妙处在于“悠然”二字，不是刻意追求，而是自然而然地流露出闲适和超脱。",
    tag: "田园",
    theme: "归隐闲适",
    level: "入门",
    keywords: ["菊花", "南山", "田园", "悠然"],
    cover: "",
  },
  {
    title: "鹊桥仙",
    author: "秦观",
    dynasty: "宋",
    line: "两情若是久长时，又岂在朝朝暮暮。",
    meaning:
      "只要两个人的感情真挚而长久，又何必一定天天相守在一起呢？",
    appreciation:
      "这句突破了单纯追求朝夕相守的爱情观，提出了更深层次的情感理解：真正的爱情在于心灵相通和长久坚守，因此显得格外深沉含蓄。",
    tag: "爱情",
    theme: "真情久长",
    level: "进阶",
    keywords: ["爱情", "相守", "久长", "秦观"],
    cover: "",
  },
  {
    title: "观书有感",
    author: "朱熹",
    dynasty: "宋",
    line: "问渠那得清如许？为有源头活水来。",
    meaning:
      "要问这池塘为什么这样清澈，是因为有源头的活水不断流入。",
    appreciation:
      "诗句表面写池水清澈，实则说明学习和思想都需要不断吸收新知识、新见解，才能保持活力和清明。以景喻理，形象鲜明，启发意义很强。",
    tag: "学习",
    theme: "求知之道",
    level: "进阶",
    keywords: ["读书", "学习", "活水", "哲理"],
    cover: "",
  },
  {
    title: "增广贤文",
    author: "佚名",
    dynasty: "古",
    line: "一寸光阴一寸金，寸金难买寸光阴。",
    meaning:
      "一点点时间就像一点点黄金那样珍贵，但黄金却买不回已经流逝的时间。",
    appreciation:
      "这句用通俗而有力的比喻说明时间的珍贵，提醒人们珍惜青春、把握当下。虽然语言口语化，但警策意味极强，因此长期流传于民间和学校教育中。",
    tag: "惜时",
    theme: "珍惜时间",
    level: "入门",
    keywords: ["时间", "珍惜", "勤学", "成长"],
    cover: "",
  },
  {
    title: "奉赠韦左丞丈二十二韵",
    author: "杜甫",
    dynasty: "唐",
    line: "读书破万卷，下笔如有神。",
    meaning:
      "读书如果读得非常广博深入，写文章时就会像有神助一样得心应手。",
    appreciation:
      "这句强调阅读积累对写作和学问的重要意义，是中国传统学习观中极有代表性的一句话。它告诉人们，能力的提升离不开长期扎实的积累。",
    tag: "学习",
    theme: "博学积累",
    level: "入门",
    keywords: ["读书", "积累", "写作", "勤学"],
    cover: "",
  },
  {
    title: "滕王阁序",
    author: "王勃",
    dynasty: "唐",
    line: "落霞与孤鹜齐飞，秋水共长天一色。",
    meaning:
      "晚霞和孤独飞翔的野鸭一起飞舞，秋天的江水与广阔的天空融成一片颜色。",
    appreciation:
      "这是写景名句中的巅峰之作，色彩、动态、空间感都极其出色。诗人将晚霞、飞鸟、秋水、长天融汇成一幅辽阔而明丽的秋景图，极富画面美与音乐感。",
    tag: "写景",
    theme: "秋江暮景",
    level: "进阶",
    keywords: ["落霞", "孤鹜", "秋水", "长天"],
    cover: "",
  },
  {
    title: "念奴娇·赤壁怀古",
    author: "苏轼",
    dynasty: "宋",
    line: "大江东去，浪淘尽，千古风流人物。",
    meaning:
      "滚滚长江向东流去，波浪冲刷淘洗尽了千百年来的英雄人物。",
    appreciation:
      "这句开篇气势磅礴，以江水永恒与历史人物短暂形成对照，既有吊古伤今的苍凉，也有纵观古今的大气，是豪放词的经典代表。",
    tag: "豪放",
    theme: "怀古咏史",
    level: "进阶",
    keywords: ["长江", "赤壁", "历史", "豪放"],
    cover: "",
  },
  {
    title: "子夜吴歌·秋歌",
    author: "李白",
    dynasty: "唐",
    line: "长安一片月，万户捣衣声。",
    meaning:
      "长安城上空洒满一片月色，千家万户都传来捣衣的声音。",
    appreciation:
      "诗人以月色与捣衣声营造出浓厚的秋夜氛围，画面清冷而富有人情味。短短两句就将空间、声音和情感融为一体，极具感染力。",
    tag: "秋夜",
    theme: "长安月夜",
    level: "进阶",
    keywords: ["长安", "月色", "秋夜", "思妇"],
    cover: "",
  },
];

function buildPoetry100() {
  return Array.from({ length: 100 }, (_, index) => {
    const base = basePoems[index % basePoems.length];
    const no = String(index + 1).padStart(3, "0");

    return {
      id: index + 1,
      title: base.title,
      author: base.author,
      dynasty: base.dynasty,
      line: base.line,
      content: base.line,
      meaning: base.meaning,
      appreciation: base.appreciation,
      tag: base.tag,
      theme: base.theme,
      level: base.level,
      keywords: base.keywords,
      cover: base.cover,
      serialNo: `POEM-${no}`,
      source: "前端本地模拟数据",
      hot: 100 - index,
    };
  });
}

const poetry100 = buildPoetry100();

export default poetry100;