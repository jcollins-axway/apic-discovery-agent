module github.com/jcollins-axway/apic-discovery-agent

go 1.16

//replace github.com/Axway/agent-sdk => /home/ubuntu/go/src/github.com/Axway/agent-sdk

require github.com/Axway/agent-sdk v1.0.20210506-0.20210511154347-26c837cd5ed3

replace (
	github.com/Shopify/sarama => github.com/elastic/sarama v0.0.0-20191122160421-355d120d0970
	github.com/dop251/goja => github.com/andrewkroh/goja v0.0.0-20190128172624-dd2ac4456e20
	github.com/fsnotify/fsevents => github.com/fsnotify/fsevents v0.1.1
)
