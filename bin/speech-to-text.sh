#!/usr/bin/env zsh

export index=(`seq 21 30`)

export TOKEN=$(gcloud auth application-default print-access-token)

for i in $index; do
  URI="gs://mozaicfm/mozaic-ep$i.mp3"

  echo $URI

  curl -X POST \
       -H "Authorization: Bearer $TOKEN" \
       -H "Content-Type: application/json; charset=utf-8" \
       --data "{
    'config': {
      'encoding': 'MP3',
      'sampleRateHertz': 44100,
      'enableWordTimeOffsets': true,
      'enableAutomaticPunctuation': true,
      'enableSpeakerDiarization': true,
      'diarizationSpeakerCount': 2,
      'language_code': 'ja-JP'
    },
    'output_config': {
       'gcs_uri':'$URI.json'
    },
    'audio':{
      'uri': '$URI'
    }
  }" "https://speech.googleapis.com/v1p1beta1/speech:longrunningrecognize"

  sleep 2
done


# curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \                                             [master ~/dotfiles/bin]:/dev/ttys003:99036 │.zshrc            224,2          89%
#      -H "Content-Type: application/json; charset=utf-8" \                                                                                                                            │
#      "https://speech.googleapis.com/v1/operations/$NAME"
