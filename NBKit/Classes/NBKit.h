






#ifdef DEBUG
#	define NB_LOG(...) NSLog(__VA_ARGS__)
#	define NB_TRACE() NSLog(@"%s", __FUNCTION__)
#	define NB_ASSERT(p) NSAssert(p, @#p)
#else
#	define NB_LOG(...)
#	define NB_TRACE()
#	define NB_ASSERT(p)
#endif

#define NB_RETAIN(obj) [(obj) retain]
#define NB_RELEASE(obj) if ((obj) != nil) { [(obj) release]; (obj) = nil; }


