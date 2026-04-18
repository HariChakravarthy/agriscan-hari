class TreatmentData {
  static const Map<String, Map<String, dynamic>> treatments = {
    'Pepper__bell___Bacterial_spot': {
      'description': 'Bacterial Spot on pepper plants causes dark, water-soaked lesions. It thrives in warm, humid conditions.',
      'severity': 'High',
      'chemical': ['Apply Copper fungicides immediately at first sign', 'Use Streptomycin (if permitted in your jurisdiction)'],
      'natural': ['Remove and burn infected material carefully', 'Improve air circulation by pruning dense foliage', 'Avoid handling plants when wet'],
      'prevention': ['Always use disease-free, certified seeds', 'Avoid overhead watering; install drip irrigation', 'Rotate crops every 2-3 years'],
      'community': ['"I found that removing the bottom 3 inches of leaves completely stopped the splash-back during rain!" - Local Farm Forum', '"Copper spray works best if applied early morning before the sun gets too hot." - Sarah J.'],
    },
    'Pepper__bell___healthy': {
      'description': 'Your pepper plant looks perfectly healthy! The leaves show no signs of spotting, curling, or bacterial deterioration.',
      'severity': 'None',
      'chemical': [],
      'natural': ['Maintain a proper watering schedule (1-2 inches per week)', 'Ensure the plant gets 6-8 hours of direct sunlight'],
      'prevention': ['Keep monitoring leaves regularly, especially after heavy rains', 'Mulch the base to retain moisture and prevent soil splash'],
      'community': ['"Don\'t overwater healthy peppers! Let the top inch of soil dry out between waterings to encourage deep roots." - Master Gardener', '"Consider adding a tiny bit of epsom salt to the soil for a magnesium boost." - Local Agri-Club'],
    },
    'Potato___Early_blight': {
      'description': 'Early Blight (Alternaria solani) causes dark, concentric rings on older potato leaves. If left untreated, it will travel up the stem and destroy the crop.',
      'severity': 'Medium',
      'chemical': ['Apply Chlorothalonil preventatively during humid weather', 'Use Mancozeb combination sprays every 7-10 days'],
      'natural': ['Remove infected lower leaves immediately using sterile shears', 'Ensure ample spacing between potato mounds for windflow', 'Apply a baking soda and soap spray to slow fungal spread'],
      'prevention': ['Implement strict crop rotation (no nightshades for 3 years)', 'Apply fungicide preventatively before humid weather systems arrive'],
      'community': ['"Early blight almost wiped out my crop last year. Now I stake my potatoes and haven\'t seen it since!" - Farming Community Board', '"Make sure you clean your pruning shears with alcohol between every single cut." - Extension Officer'],
    },
    'Potato___Late_blight': {
      'description': 'Late Blight is a rapidly spreading, highly destructive disease causing dark, water-soaked spots on leaves. It was the cause of the historic Irish Potato Famine.',
      'severity': 'Critical',
      'chemical': ['Apply Mancozeb immediately', 'Use Dimethomorph or other systemic curative fungicides immediately'],
      'natural': ['Destroy infected foliage immediately (do NOT compost)', 'Harvest any usable tubers immediately to prevent ground rot'],
      'prevention': ['Use strictly certified seed potatoes', 'Avoid excessive moisture and overhead irrigation', 'Plant resistant potato varieties if available in your region'],
      'community': ['"If you see late blight, you must act the exact same day. It spreads overnight in high humidity!" - Regional Coop', '"Do not put infected leaves in your compost bin, the spores will survive the winter." - Community Advice'],
    },
    'Potato___healthy': {
      'description': 'Your potato plant appears completely healthy! The leaf structure is sound and shows no signs of fungal or bacterial decay.',
      'severity': 'None',
      'chemical': [],
      'natural': ['Provide even moisture deeply at the root zone', 'Monitor for Colorado Potato Beetles underneath the leaves'],
      'prevention': ['Hill the potatoes properly as they grow to protect tubers from sunlight', 'Maintain a consistent watering schedule to prevent tuber cracking'],
      'community': ['"Healthy potatoes love loose soil. Make sure you hill them up with extra straw or light soil as they grow!" - Urban Farmer Network', '"I spray neem oil preventatively every two weeks even on healthy plants to keep the beetles away." - Local Growers'],
    },
    'Tomato_Bacterial_spot': {
      'description': 'Bacterial Spot is caused by Xanthomonas bacteria. It causes dark, water-soaked spots on leaves and fruits, leading to extreme defoliation and ruined fruit yield.',
      'severity': 'High',
      'chemical': [
        'Apply Copper-based bactericides (copper hydroxide, copper sulfate)',
        'Use Copper + Mancozeb combination spray for enhanced efficacy',
        'Streptomycin sulfate (where permitted by agricultural law)',
      ],
      'natural': [
        'Apply Neem oil spray heavily to reduce bacterial spread',
        'Remove and completely destroy infected leaves/fruits immediately',
        'Avoid all overhead irrigation — strictly use drip irrigation',
      ],
      'prevention': [
        'Use certified disease-free seeds from reputable vendors',
        'Rotate crops — do not plant tomatoes in same spot for 2+ years',
        'Maintain proper plant spacing for maximum airflow',
      ],
      'community': ['"I switch to drip tape instead of sprinklers and my bacterial spot issues completely disappeared." - Tom M.', '"Remember that copper sprays can wash off in heavy rain, reapply!" - Farmer Forum'],
    },
    'Tomato_Late_blight': {
      'description': 'Late Blight (Phytophthora infestans) is a devastating disease forming dark brown lesions on leaves and stems, with white mold on the underside. Can destroy entire crops in days.',
      'severity': 'Critical',
      'chemical': [
        'Chlorothalonil (Bravo) — apply preventatively',
        'Metalaxyl + Mancozeb (Ridomil Gold) for systemic control',
        'Cymoxanil-based curative fungicides',
      ],
      'natural': [
        'Copper-based fungicide spray (Bordeaux mixture) applied early',
        'Remove and bag infected plant material immediately',
        'Improve drainage around plants massively',
      ],
      'prevention': [
        'Plant highly resistant varieties (Mountain Magic, Defiant)',
        'Avoid wetting foliage completely — water strictly at the base',
        'Monitor local weather — apply preventive fungicide before wet weather',
      ],
      'community': ['"Late blight took my whole field in 3 days. Now I use an automated weather alert system to spray before the rain hits." - Ag-Tech Forum', '"Always bag the infected plants, burning them is safer." - Community Hub'],
    },
    'Tomato_Early_blight': {
      'description': 'Early Blight (Alternaria solani) causes dark concentric rings (target-like spots) on lower leaves, leading to premature defoliation if left unchecked.',
      'severity': 'Medium',
      'chemical': [
        'Apply Mancozeb fungicide spray',
        'Use Azoxystrobin (Quadris)',
        'Apply Chlorothalonil every 7-14 days',
      ],
      'natural': [
        'Create a baking soda solution (1 tbsp per gallon water) as a mild combatant',
        'Neem oil spray every 7–10 days',
        'Aggressively prune and remove lower infected leaves',
      ],
      'prevention': [
        'Mulch heavily around base to prevent soil splash entirely',
        'Stake and trellis plants to improve airflow',
        'Water early in the day so leaves dry before nightfall',
      ],
      'community': ['"Mulch! Mulch! Mulch! A good 3-inch layer of straw stops the early blight spores from splashing up out of the soil." - Master Gardener Community'],
    },
    'Tomato_Leaf_Mold': {
      'description': 'Leaf Mold (Passalora fulva) creates pale yellowish spots on upper leaf surface and olive-green to gray mold on the underside. Highly common in humid greenhouse environments.',
      'severity': 'Medium',
      'chemical': [
        'Apply Chlorothalonil spray',
        'Use Mancozeb + Copper oxychloride combinations',
      ],
      'natural': [
        'Improve greenhouse ventilation aggressively (install fans)',
        'Reduce relative humidity below 85% immediately',
        'Apply Neem oil spray heavily on affected areas',
      ],
      'prevention': [
        'Use specifically resistant tomato varieties',
        'Prune lower leaves and suckers for much better airflow',
        'Space plants adequately in the high-tunnel or greenhouse',
      ],
      'community': ['"If you are growing in a high tunnel, roll up the sides every single morning. Stagnant air breeds leaf mold." - High Tunnel Growers Group'],
    },
    'Tomato_Septoria_leaf_spot': {
      'description': 'Septoria Leaf Spot causes hundreds of small circular spots with dark borders and gray centers on lower leaves. It rapidly spreads upward, causing complete defoliation.',
      'severity': 'Medium',
      'chemical': [
        'Apply Mancozeb + Chlorothalonil combination',
        'Use standard Copper-based fungicides',
        'Apply Azoxystrobin',
      ],
      'natural': [
        'Remove and completely dispose of infected leaves (do not compost)',
        'Apply compost tea spray as a natural biofungicide',
      ],
      'prevention': [
        'Rotate crops strictly every 2 years',
        'Water at soil level only, never overhead',
        'Keep garden beds totally weed-free to improve airflow',
      ],
      'community': ['"Septoria looks awful but if you catch it early and strip the bottom leaves, the top of the plant will still produce great tomatoes!" - Community Forum'],
    },
    'Tomato_Spider_mites_Two_spotted_spider_mite': {
      'description': 'Spider Mites (Tetranychus urticae) are tiny arachnids that cause stippled yellowing on leaves due to cell damage. Fine webbing is visible under leaves in heavy infestations.',
      'severity': 'Medium',
      'chemical': [
        'Apply an Abamectin miticide directly under leaves',
        'Use Bifenazate (Acramite)',
        'Apply a strong Insecticidal soap spray',
      ],
      'natural': [
        'Use a strong water spray from a hose to physically dislodge mites from leaves',
        'Neem oil spray — repeat every 5–7 days to break the lifecycle',
        'Introduce predatory mites (Phytoseiulus persimilis) to the greenhouse',
      ],
      'prevention': [
        'Keep plants very well-watered (drought-stressed plants attract mites heavily)',
        'Avoid dusty conditions around the crops',
      ],
      'community': ['"Before buying expensive chemicals, I literally just blasted the underside of my plants with a hose every morning for a week. The mites hated it and left!" - Organic Farmers Guild'],
    },
    'Tomato__Target_Spot': {
      'description': 'Target Spot (Corynespora cassiicola) causes brown spots with concentric rings on all plant parts. Can severely damage fruit quality and cause heavy yield loss.',
      'severity': 'High',
      'chemical': [
        'Apply Azoxystrobin (Amistar)',
        'Use Boscalid + Pyraclostrobin (Pristine)',
        'Apply Trifloxystrobin (Flint)',
      ],
      'natural': [
        'Apply a Copper hydroxide spray immediately',
        'Remove infected plant tissue promptly from the field',
        'Improve airflow by aggressive pruning of non-fruiting branches',
      ],
      'prevention': [
        'Avoid prolonged leaf wetness at all costs',
        'Plant in highly well-drained soil',
        'Start spraying preventively during highly humid periods',
      ],
      'community': ['"Target spot loves standing water. I dug small drainage trenches between my rows and it helped immensely." - Local Ag Officer'],
    },
    'Tomato__Tomato_Yellow_Leaf_Curl_Virus': {
      'description': 'TYLCV is a devastating systemic viral disease transmitted entirely by whiteflies. It causes severe leaf curling, extreme yellowing, and stunted growth. Infected plants rarely recover.',
      'severity': 'Critical',
      'chemical': [
        'Apply Imidacloprid (for aggressive whitefly vector control)',
        'Use Thiamethoxam — systemic insecticide',
        'Disclaimer: No direct chemical cure exists for the virus itself',
      ],
      'natural': [
        'Deploy dozens of yellow sticky traps to monitor and reduce whitefly populations',
        'Use Neem oil spray to naturally repel whiteflies (preventive)',
        'Pull up, remove, and burn infected plants immediately',
      ],
      'prevention': [
        'Only use TYLCV-resistant plant varieties (highly recommended)',
        'Use silver reflective mulch to confuse and repel whiteflies',
        'Install extremely fine insect-proof netting in your greenhouse',
      ],
      'community': ['"By the time the leaves curl, the plant is a goner. Your entire focus must be on killing the whiteflies so they don\'t bite your healthy plants next." - Veteran Farmer Forum'],
    },
    'Tomato__Tomato_mosaic_virus': {
      'description': 'Tomato Mosaic Virus (ToMV) causes light/dark green mosaic patterns on leaves, severe leaf distortion, and massively reduced fruit quality. Spreads mechanically through tools and hands.',
      'severity': 'High',
      'chemical': [
        'No chemical cure exists — focus entirely on prevention',
        'Disinfect all pruning tools with 1% sodium hypochlorite (bleach) between every plant',
      ],
      'natural': [
        'Remove and completely destroy infected plants (burn them)',
        'Wash hands thoroughly with soap and water before handling any plants',
        'Avoid smoking or using tobacco products near plants (Tobacco Mosaic Virus transfers easily)',
      ],
      'prevention': [
        'Strictly use certified virus-free seeds',
        'Use highly resistant varieties (e.g., Motelle)',
        'Sanitize all tomato stakes and cages at the end of every season',
      ],
      'community': ['"I caught ToMV because I was rolling cigarettes while planting my seedlings. Wash your hands thoroughly, especially if you handle tobacco!" - Community Caution Board'],
    },
    'Tomato_healthy': {
      'description': 'Your tomato plant appears incredibly healthy! Continue with best agricultural practices to maintain peak crop health, high yield, and prevent future disease.',
      'severity': 'None',
      'chemical': [],
      'natural': [
        'Continue regular, deep watering strictly at the base of the plant',
        'Apply a balanced N-P-K organic fertilizer as needed',
        'Monitor weekly for early signs of aphids, hornworms, or spotting',
      ],
      'prevention': [
        'Maintain proper plant spacing (at least 24 inches apart)',
        'Rotate crops each season (never plant tomatoes in the same spot twice in a row)',
        'Prune the suckers regularly to maintain airflow',
      ],
      'community': ['"A healthy plant is a happy plant! I add a handful of crushed eggshells to the base of my healthy tomatoes to prevent blossom end rot later in the season." - Urban Gardening Network', '"Keep checking the underside of those healthy leaves for eggs once a week!" - Farm Extension'],
    },
  };

  static Map<String, dynamic> getTreatment(String label) {
    return treatments[label] ??
        {
          'description': 'Disease information not available.',
          'severity': 'Unknown',
          'chemical': [],
          'natural': ['Consult a local agricultural extension officer.'],
          'prevention': [],
          'community': ['"When in doubt, take a physical sample to your local university extension office!" - Standard Advice'],
        };
  }
}
