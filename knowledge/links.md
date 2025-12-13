
---

# 3️⃣ `LINK_MAP.md`

```markdown
# RustyEddy.com Internal Link Map

This document defines the core content hubs and preferred internal linking strategy.

---

## Pillar Content

### IoT & Edge Computing
- /iot/building-iot-device-manager-in-go/
- /iot/iot-device-management/
- /iot/edge-device-architecture/

### Software Architecture & SDLC
- /software/sdlc-for-small-teams/
- /software/system-design-principles/

### Notes
- /linux/fedora-iot-overview/
- /linux/custom-fedora-images/
- /linux/embedded-linux-basics/
- /go/interfaces-and-abstractions/
- /go/generics-in-real-systems/
- /go/concurrency-patterns/

---

## Topic Clusters

### IoT Device Management Cluster
**Pillar**
- Building an IoT Device Manager in Go

**Supporting Articles**
- Device abstraction layers
- Hardware vs application boundaries
- Messaging and telemetry
- Device lifecycle management
- Testing with mocked devices

---

## Preferred Anchor Text

| Topic | Preferred Anchor |
|------|------------------|
| IoT device manager | IoT device manager |
| Device abstraction | device abstraction layer |
| Go interfaces | Go interfaces |
| Edge computing | edge computing |
| Fedora IoT | Fedora IoT |

Avoid generic anchors like:
- “click here”
- “this article”

---

## Internal Linking Rules
- Link pillars → supporting posts
- Supporting posts → pillar
- Prefer linking early in the article
- Avoid excessive links in a single paragraph

---

## TODO / Future Content
- Add diagrams-focused IoT architecture article
- Add operational IoT concerns (updates, failures, observability)
- Add testing & simulation for embedded systems
