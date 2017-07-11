import sys
import json

def hw(tweet_file):
    terms = {} # initialize an empty dictionary
    total_terms = 0
    for line in tweet_file:
        tweet = json.loads(line)
        if 'entities' not in tweet: 
            continue
        if 'hashtags' not in tweet['entities']:
            continue
        for h in tweet['entities']['hashtags']:
            term = h['text']
            if term in terms: terms[term] += 1
            else: terms[term] = 1
            total_terms +=1

    top_ten = sorted(terms.items(), key = lambda x: x[1] , reverse = True)[:10]
    for t in top_ten:
        print t[0], t[1]



def lines(fp):
    print str(len(fp.readlines()))

def main():
    tweet_file = open(sys.argv[1])
    hw(tweet_file)
    tweet_file.close()

if __name__ == '__main__':
    main()