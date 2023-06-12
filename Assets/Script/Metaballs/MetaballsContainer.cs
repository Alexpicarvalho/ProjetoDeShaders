//using Unity.VisualScripting;
using TreeEditor;
using UnityEngine;

public class MetaballsContainer : MonoBehaviour
{
    private static readonly int s_SpheresProp = Shader.PropertyToID("_Spheres");
    private static readonly int s_SphereCountProp = Shader.PropertyToID("_SphereCount");

    [SerializeField, Range(1f, 20f)] private int m_MetaballCount;

    private Vector4[] m_Spheres = new Vector4[20];
    private Vector4[] m_SpheresWorld = new Vector4[20];

    private Vector3[] m_SphereTargets = new Vector3[20];
    private float[] m_SphereSpeeds = new float[20];

    private Material m_Material;

    private void Start()
    {
        var meshRenderer = GetComponent<MeshRenderer>();

        if (meshRenderer)
        {
            m_Material = meshRenderer.material;
        }

        float containerRadius = transform.localScale.x * 0.2f;
        float maxRadius = containerRadius * 0.25f;

        for (int i = 0; i < m_Spheres.Length; i++)
        {
            float radius = Random.Range(0.05f, maxRadius);

            m_Spheres[i] = /*transform.position + */
                Random.insideUnitSphere * (containerRadius - radius);

            m_Spheres[i].w = radius;

            m_SphereSpeeds[i] = Random.Range(0.05f, 0.2f);

            m_SphereTargets[i] = /*transform.position +*/
                Random.insideUnitSphere * (containerRadius - radius);
        }
    }

    private void Update()
    {
        UpdateMetaballs();

        UpdateMaterialProperties();
    }

    private void UpdateMetaballs()
    {
        float containerRadiusX = transform.localScale.x * 0.7f;
        float containerRadiusY = transform.localScale.y * 0.7f;

        for (int i = 0;  i < m_MetaballCount; i++)
        {
            float radius = m_Spheres[i].w;

            Vector3 diff = m_SphereTargets[i] - (Vector3)m_Spheres[i];

            if (diff.sqrMagnitude < 0.01f)
            {
                m_SphereTargets[i] =  /*transform.position +*/
                Random.insideUnitSphere * (containerRadiusX - radius);
                m_SphereTargets[i] = /*transform.position +*/
               Random.insideUnitSphere * (containerRadiusY - radius);

                return;
            }

            m_Spheres[i] += (Vector4)(m_SphereSpeeds[i] * Time.deltaTime * diff.normalized);

            m_Spheres[i].w = radius;
        }
    }

    private void UpdateMaterialProperties()
    {
        if (!m_Material) return;

        m_Material.SetInt(s_SphereCountProp, m_MetaballCount);
        for (int i = 0; i < m_MetaballCount; i++)
        {
            m_SpheresWorld[i] = m_Spheres[i] + new Vector4(transform.position.x, transform.position.y, transform.position.z, 0);

        }
        m_Material.SetVectorArray(s_SpheresProp, m_SpheresWorld);
    }
}
