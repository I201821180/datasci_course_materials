import sys
import json

def hw(sent_file, tweet_file):
    scores = {} # initialize an empty dictionary
    for line in sent_file:
        term, score  = line.split('\t')  # The file is tab-delimited.
        scores[term] = int(score)

    for line in tweet_file:
        tweet = json.loads(line)
        tweet_score = 0
        if 'text' in tweet: 
            for word in tweet['text'].split():
                if word in scores: tweet_score += scores[word]
            print tweet_score



def lines(fp):
    print str(len(fp.readlines()))

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    hw(sent_file, tweet_file)
    sent_file.close()
    tweet_file.close()

if __name__ == '__main__':
    main()
