import sys
import json

def hw(sent_file, tweet_file):
    scores = {} # initialize an empty dictionary
    for line in sent_file:
        term, score  = line.split('\t')  # The file is tab-delimited.
        scores[term] = int(score)

    happiness = {}
    for line in tweet_file:
        tweet = json.loads(line)
        tweet_score = 0
        if 'text' in tweet and 'place' in tweet:
            if tweet['place'] is not None and 'country_code' in tweet['place'] and tweet['place']['country_code'] == 'US' and 'full_name' in tweet['place']:
                s = tweet['place']['full_name'].split()
                state = None
                if len(s) > 1: state = s[1] 
                if state in states:
                    for word in tweet['text'].split():
                        if word in scores: tweet_score += scores[word]
                    if state in happiness:
                        prev_score, prev_count = happiness[state]
                        happiness[state] = (prev_score + tweet_score, prev_count + 1)
                    else:
                        happiness[state] = (tweet_score, 1)
    avg_happy = {}
    for s in happiness:
        avg_happy[s] = float(happiness[s][0])/happiness[s][1]
      
    max_state = sorted(avg_happy.items(), key = lambda x: x[1] , reverse = True)[0]
    print max_state[0]

states = {
        'AK': 'Alaska',
        'AL': 'Alabama',
        'AR': 'Arkansas',
        'AS': 'American Samoa',
        'AZ': 'Arizona',
        'CA': 'California',
        'CO': 'Colorado',
        'CT': 'Connecticut',
        'DC': 'District of Columbia',
        'DE': 'Delaware',
        'FL': 'Florida',
        'GA': 'Georgia',
        'GU': 'Guam',
        'HI': 'Hawaii',
        'IA': 'Iowa',
        'ID': 'Idaho',
        'IL': 'Illinois',
        'IN': 'Indiana',
        'KS': 'Kansas',
        'KY': 'Kentucky',
        'LA': 'Louisiana',
        'MA': 'Massachusetts',
        'MD': 'Maryland',
        'ME': 'Maine',
        'MI': 'Michigan',
        'MN': 'Minnesota',
        'MO': 'Missouri',
        'MP': 'Northern Mariana Islands',
        'MS': 'Mississippi',
        'MT': 'Montana',
        'NA': 'National',
        'NC': 'North Carolina',
        'ND': 'North Dakota',
        'NE': 'Nebraska',
        'NH': 'New Hampshire',
        'NJ': 'New Jersey',
        'NM': 'New Mexico',
        'NV': 'Nevada',
        'NY': 'New York',
        'OH': 'Ohio',
        'OK': 'Oklahoma',
        'OR': 'Oregon',
        'PA': 'Pennsylvania',
        'PR': 'Puerto Rico',
        'RI': 'Rhode Island',
        'SC': 'South Carolina',
        'SD': 'South Dakota',
        'TN': 'Tennessee',
        'TX': 'Texas',
        'UT': 'Utah',
        'VA': 'Virginia',
        'VI': 'Virgin Islands',
        'VT': 'Vermont',
        'WA': 'Washington',
        'WI': 'Wisconsin',
        'WV': 'West Virginia',
        'WY': 'Wyoming'
}

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    hw(sent_file, tweet_file)
    sent_file.close()
    tweet_file.close()

if __name__ == '__main__':
    main()